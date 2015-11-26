require 'fog'
#require 'openssl' #adicionar essa linha para usar o https
require 'redis'
require 'redis-namespace'
require 'net/http'
require 'uri'

class BatchTccs
  include Sidekiq::Worker

  def initialize(link_hours)
    logger.debug('>>> inicializando Worker')
    # @auth_url     = 'http://swift.setic.ufsc.br:80/auth/v1.0/'
    begin
      @auth_url     = Settings.swift_auth_url
    rescue
      @auth_url     = ''
    end

    # @auth_manager = 'http://swift.setic.ufsc.br:80/v1.0/AUTH_unasus'
    # @store_url    = 'http://swift.setic.ufsc.br:80'

    # @user     = 'unasus:readwrite'
    # @password = 'TccUnasus_2'
    begin
      @user     = Settings.swift_user
      @password = Settings.swift_password
    rescue
      @user     = ''
      @password = ''
    end


    # NÃO APAGAR LINHA ABAIXO. ela server para setar no servidor a chave de assinatura para URLs temporárias
    # Se necessário apenas renovar a chave
    # @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935' }
    #     @temp_url_key = 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935'
    #     @auth_token   = 'AUTH_tk847d7560d70f4892ba4a331552f2501d'
    begin
      @temp_url_key = Settings.swift_temp_url_key
      @auth_token   = get_auth_token  # Settings.swift_auth_token
    rescue
      @temp_url_key = ''
      @auth_token   = ''
    end
    # 24 horas = 86400
    # 1 hora = 3600
    # @seconds_URL_lives = 3600
    begin
      logger.debug('>>> @seconds_URL_lives ')
      logger.debug(">>> Settings.swift_seconds_URL_lives=#{Settings.swift_seconds_URL_lives}")
      logger.debug(">>> link_hours=#{link_hours}")
      @seconds_URL_lives = (link_hours < 0) ? Settings.swift_seconds_URL_lives : link_hours*3600
    rescue
      @seconds_URL_lives = 7200
    end
    logger.debug(">>> @seconds_URL_lives=#{@seconds_URL_lives}")


    Excon.defaults[:ssl_verify_peer] = false
    #    Excon.defaults[:port] = 80
    #    Excon.defaults[:scheme] = 'http'

    logger.debug('>>> Conectando ao Redis: ')
    @redis_connection = Redis.new
    logger.debug('OK <<<')

    logger.debug('>>> Inicializando Worker: ')
    begin
      @service = Fog::Storage.new(:provider => 'OpenStack',
                                  :openstack_auth_url => @auth_url,
                                  :openstack_username => @user,
                                  :openstack_api_key  => @password
#                                  :connection_options  => {:port => 80, :scheme =>  'http'}
      )
    rescue
      @service = nil
      raise '>>> OpenStack não pode ser aberto! Verifique a configuração: tcc_config.yml(auth_url, user, password).'
    end
    logger.debug('OK <<<')

    logger.info('+++ Inicialização do worker finalizada <<<')
  end

  def temp_url_key
    @temp_url_key
  end

  # bt = BatchTccs.new;
  # bt.generate_email([12140, 12141, 12142], 'Roberto Cunha', 'robertosilvino@gmail.com')
  # bt.generate_email([12140, 12141, 12142], 'Thiago Ângelo Gelaim', 't.gelaim@gmail.com')
  # bt.generate_email([12140, 12141, 12142], 'Alexandra Crispim', 'acboing@gmail.com')
  # bt.generate_email([12140, 12141, 12142], 'Luiz Henrique Salazar', 'luizhsalazar@gmail.com')
  def generate_email(moodle_ids, name, mail_to)
    logger.debug('>>> inicializando Gerador de email')

    moodle_id = moodle_ids[0].to_s
    # pega o estudante para poder procurar o tcc
    logger.debug('>>> Procurando url da atividade para colocar no e-mail: ')
    student = Person.find_by_moodle_id(moodle_id)
    tcc = Tcc.find_by_student_id (student.id)

    # informa o link para a atividade do TCC no moodle
    activity_url = tcc.tcc_definition.activity_url
    logger.debug('OK <<<')

    # gera o arquivo metalink para ser anexado ao e-mail
    metalink_file = generate_metalink(moodle_ids)

    Mailer.tccs_batch_print(name, mail_to, metalink_file, activity_url).deliver unless mail_to.blank? || mail_to.nil?

    logger.info('+++ Geração de email encerrada <<<')
  end

  #@param moodle_ids lista com os tccs (moodle_id) que deverão ser baixados
  #@return
  def generate_metalink(moodle_ids)
    logger.debug(">>> Inicializando gerador de metalink para: #{moodle_ids}")

    logger.debug('>>> Criando objeto de metalink: ')
    metalilnk = Metalink::Metalink.new
    logger.debug('OK <<<')

    moodle_ids.each { | moodle_id_each |
      logger.debug('>>> Procurando dados do estudante: ')
      moodle_id = moodle_id_each.to_s

      # pega o estudante para poder procurar o tcc
      student = Person.find_by_moodle_id(moodle_id)
      tcc = Tcc.find_by_student_id(student.id)
      logger.debug("(encontrado) #{moodle_id} / #{student.name}")

      # monta o nome do arquivo para gravação, com o nome do estudante, para facilitar o armazenamento
      # e a busca no download para o usuário final
      filename = "#{tcc.student.name}.pdf"

      # pega o arquivo mais atualizado
      remote_file = open_last_pdf_tcc(tcc)

      if remote_file
        url_remote_file = CGI.escapeHTML(generate_url(remote_file)+'&filename='+filename)
        logger.debug(">>> Adicionando #{tcc.student.name} - #{url_remote_file}")
        urls = [{ :type => 'http', :url => url_remote_file }]

        # metalilnk.add_binary(filename, remote_file.body, urls)
        # end
      else
        urls = [{ :type => 'http',
                  :url => 'ERRO: verifique a configuração de tcc_config.yml(auth_url, user, password)'}]

      end
      metalilnk.add_binary(filename, remote_file.body, urls)
    }

    logger.debug(">>> Finalizando gerador de metalink para: #{moodle_ids}")
    metalilnk.to_s
  end

  def name_space(tcc)
    "#{Settings.instance_guid}_.._#{tcc.tcc_definition.course_id}.__.#{tcc.tcc_definition.moodle_instance_id}"
  end

  def generate_pdf_url(tcc)
    remote_file = open_last_pdf_tcc(tcc)
    generate_url(remote_file)
  end

  # Abre o pdf mais atual do estudante. Se estiver desatualizado gera novamente, salva e retorna o novo
  #
  def open_last_pdf_tcc(tcc)
    logger.debug('>>> Procura abrir o pdf mais atualizado')
    if tcc.nil?
      raise '>>> Tcc solicitado do usuário não disponível'
    elsif @service.nil?
      raise '>>> Serviço de dados não disponível'
    end
    moodle_id = tcc.student.moodle_id.to_s

    logger.debug('>>> Inicializa o namespace do redis')
    @namespaced_redis = Redis::Namespace.new(name_space(tcc), :redis => @redis_connection)
    logger.debug(">>> namespace = #{@namespaced_redis}")

    logger.debug('>>> Verifica o Serviço de cache Redis')
    if @namespaced_redis.nil?
      puts('>>> Serviço de cache local não disponível')
      return false
    end

    logger.debug('>>> Verifica o cache do pdf')
    tcc_updated_at = tcc.updated_at.to_s

    file_load = false
    if @namespaced_redis.exists(moodle_id)
      logger.debug('>>> Encontrados dados no cache de data')
      cache_updated_at = @namespaced_redis.get(moodle_id)
      logger.debug(">>> Data de alteração do tcc no cache = #{cache_updated_at}")

      if cache_updated_at.eql?(tcc_updated_at)
        logger.debug('>>> data da impressão é igual a data de update do TCC')

        remote_file = open_remote_file(moodle_id, name_space(tcc))
        logger.debug('>>> retornado o objeto salvo em cache')

        # se o remote_file for nil (não encontrou objeto remoto) então gera novo PDF,
        # atualizando a data de update com a do Tcc
        if remote_file.nil?
          logger.debug('>>> Se o remote_file for nil (não encontrou objeto remoto) então gera novo PDF, ')
          logger.debug('atualizando a data de update com a do Tcc')
          remote_file = save_pdf_tcc(tcc)
        else
          file_load = true
        end
      else
        logger.debug('>>> data da impressão é diferente da data de update do TCC')
        # senão deve salvar o objeto, atualizando a data de update com a do Tcc
        remote_file = save_pdf_tcc(tcc)
      end
    else
      logger.debug('>>> Não encontrados dados no cache de data')
      # senão deve salvar o objeto, atualizando a data de update com a do Tcc
      remote_file = save_pdf_tcc(tcc)
    end
    logger.info("+++ Arquivo pdf #{ file_load ? 'recuperado' : 'gerado'} para: #{moodle_id} - #{remote_file}")
    remote_file
  end

  def generate_url(remote_file)
    #generate_temp_url('GET', remote_file.public_url.sub!('https:', 'http:').sub!(':443',':80'), @seconds_URL_lives, @temp_url_key )
    generate_temp_url('GET', remote_file.public_url, @seconds_URL_lives, @temp_url_key )
  end

  def open_temp_pdf(moodle_id)
    input = File.join(temp_dir, "#{moodle_id}.pdf")
    File.open(input, 'r+')
  end

  def save_pdf_tcc(tcc)
    moodle_id = tcc.student.moodle_id

    #verifica os objetos de trabalho
    if tcc.nil?
      logger.debug(">>> Tcc solicitado do usuário #{moodle_id} não disponível")
      return false
    elsif @service.nil?
      logger.debug('>>> Serviço de dados não disponível')
      return false
    end

    # abre o redis com o namespace
    @namespaced_redis = Redis::Namespace.new(name_space(tcc), :redis => @redis_connection)

    #verifica os objetos de trabalho
    if @namespaced_redis.nil?
      logger.debug('>>> Serviço de cache local não disponível')
      return false
    end

    # gera o pdf
    logger.debug('>>> gera o pdf: ')
    pdf_service = PDFService.new(moodle_id)
    pdf_stream = pdf_service.generate_pdf
    logger.debug('OK <<<')

    # salva arquivo remoto
    remote_file = save_remote_file(moodle_id, name_space(tcc), pdf_stream)

    # salva o objeto atualizando a data de update com a do Tcc
    logger.debug('>>> salva o cahce da data de update com a do Tcc: ')
    @namespaced_redis.set(moodle_id, "#{tcc.updated_at}")
    logger.debug('OK <<<')

    remote_file
  end

  def open_remote_file(moodle_id, name_space)
    logger.debug('>>> Retorna arquivo remoto: ')
    directory = open_directory(name_space)
    remote_file = directory.files.get(moodle_id.to_s)
    logger.debug('OK <<<')
    remote_file
  end

  def save_remote_file(moodle_id, name_space, pdf_stream)
    logger.debug('>>> Salva arquivo remoto: ')
    # grava pdf remotamente
    directory = open_directory(name_space)
    remote_file = directory.files.create( :key  => moodle_id.to_s, :body => pdf_stream)
    logger.debug('OK <<<')
    remote_file
  end

  private

  def get_auth_token
    url = URI.parse(@auth_url)

    req = Net::HTTP::Get.new(url.path)
    req.add_field('X-Auth-User', @user)
    req.add_field('X-Auth-Key', @password)

    res = Net::HTTP.new(url.host, url.port).start do |http|
      http.request(req)
    end

    # puts res.header
    # res.each_header do |key, value|
    #   puts "#{key} => #{value}"
    # end
    begin
      res.header['x-auth-token']
    rescue
      ''
    end
  end

  def generate_temp_url(method, url, seconds, key)

    # OpenStack DocumentationTemporary URL middleware
    # http://docs.openstack.org/api/openstack-object-storage/1.0/content/tempurl.html

    # @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935' }
    # @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => '' }

    # response = @service.head_containers

    # generate_signature('GET', 'https://swift.setic.ufsc.br:8080/v1/AUTH_unasus/tcc92_t/12140', 120, 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935' )
    # generate_signature('GET', 'https://swift.setic.ufsc.br:8080/v1/AUTH_unasus/tcc92_t/Acir Henrique Truppel (201405050)', 120, 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935' )

    #
    #   puts "Syntax: <method> <url> <seconds> <key>"
    # 24 horas = 86400
    # 1 hora = 3600
    #   puts ("Example: PUT https://storage101.dfw1.clouddrive.com/v1/" +
    #   puts ("Example: GET https://storage101.dfw1.clouddrive.com/v1/" +
    #            "MossoCloudFS_12345678-9abc-def0-1234-56789abcdef0/" +
    #            "container/path/to/object.file 60 my_shared_secret_key")

    # GET http://swift.setic.ufsc.br:80/v1/AUTH_unasus/unasus2.yoda%3B258_9/12814 7200 f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935
    method = method.upcase
    base_url, object_path = url.split(/\/v1\//)
    object_path = '/v1/' + object_path
    seconds = seconds.to_i
    expires = (Time.now + seconds).to_i
    hmac_body = "#{method}\n#{expires}\n#{object_path}"
    sig = OpenSSL::HMAC.hexdigest("sha1", key, hmac_body)
    temp_url = "#{base_url}#{object_path}?" +
        "temp_url_sig=#{sig}&temp_url_expires=#{expires}"
    logger.debug("Temporary URL = #{temp_url}")
    temp_url
  end

  def temp_dir
    path = File.join(Rails.root, 'tmp', 'batch-print', "#{Process.pid}-#{Thread.current.hash}")
    FileUtils.mkdir_p(path)
    path
  end

  def open_directory(directoryName)
    directory = @service.directories.get(directoryName)
    if directory == nil
      directory = @service.directories.create :key => directoryName
    end
    directory
  end

end

# To retrieve a list of directories:
# @service.directories

#response = @
#response.status

# pdfTex = pdf_service.generate_tex
# File.open(filename(pdf_service.tcc.student.name,'tex'), 'w+') do |f|
#   f.write(pdfTex)
# end

# file = directory.files.create(:key  => 'Acir Henrique Truppel (201405050)', :body => File.open("tmp/Acir Henrique Truppel (201405050).pdf"))

# file = directory.files.get("key")
# file = directory.files.get("12140")
# file = directory.files.get("Acir Henrique Truppel (201405050)")
# puts file.public_url

# Download files
#================
# File.open('downloaded-file.jpg', 'w') do | f |
#   directory.files.get("my_big_file.jpg") do | data, remaining, content_length |
#     f.syswrite data
#   end
# end



# require 'securerandom'
# SecureRandom.hex(32)

# Gerar metalink
#curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus -X GET -H "X-Auth-Token: AUTH_tkb39487498dad4ad1a792c261a64931ed" -H "X-Account-Meta-Temp-Url-Key: 2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d"
# t = Metalink::Metalink.new
# t.add_file("/path/to/some/file.txt", [{ :type => "http", :url => "http://example.com/some/file.txt" }]
# puts t.to_s
# File.open('/temp/tccs.metalink', 'w+') do |f|  f.write(t.to_s) end
# abrir arquivo com (botão da direita sobre arquivo) firefox
# selecionar opção "dTa OneClick!"



#http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
# Create TempURL (in Ruby)
# require "openssl"
#
# unless ARGV.length == 4
#   puts "Syntax: <method> <url> <seconds> <key>"
#   puts ("Example: GET https://storage101.dfw1.clouddrive.com/v1/" +
#            "MossoCloudFS_12345678-9abc-def0-1234-56789abcdef0/" +
#            "container/path/to/object.file 60 my_shared_secret_key")
# else
#   method, url, seconds, key = ARGV
#   method = method.upcase
#   base_url, object_path = url.split(/\/v1\//)
#   object_path = '/v1/' + object_path
#   seconds = seconds.to_i
#   expires = (Time.now + seconds).to_i
#   hmac_body = "#{method}\n#{expires}\n#{object_path}"
#   sig = OpenSSL::HMAC.hexdigest("sha1", key, hmac_body)
#   puts ("#{base_url}#{object_path}?" +
#            "temp_url_sig=#{sig}&temp_url_expires=#{expires}")
# end
# http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
#
# http://docs.rackspace.com/files/api/v1/cf-devguide/content/TempURL-d1a4450.html
#
# Temporary URL
#
# http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html

# curl -i -k http://swift.setic.ufsc.br:80/auth/v1.0/  -H "X-Auth-User: zzzzzz" -H "X-Auth-Key: xxxxx"

# curl -i -k https://swift.setic.ufsc.br:8080/v1/AUTH_unasus/tcc92_1/Acir%20Henrique%20Truppel%20%28201405050%29 -X GET -H "X-Auth-Token: AUTH_tkd2fb252ad93940b981b62865f4f8f8b8" > /tmp/xxx.pdf

# curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus/unasus2.yoda%3B258_9/12814  -X GET -H "X-Auth-Token: AUTH_tkb39487498dad4ad1a792c261a64931ed" > /tmp/xxx.pdf

# http://swift.setic.ufsc.br:80/v1/AUTH_unasus/unasus2.yoda%3B258_9/12814?temp_url_sig=2ddfa7ef4c1f2c7b5eb92d84786a88f954c1d25b&temp_url_expires=1448509999&filename=My+Test+File.pdf

# curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus/unasus2.yoda%3B258_9/12814?temp_url_sig=ddd275f23a329688490d942dc46a3fea983115a6&temp_url_expires=1448555313

# curl -i -k http://swift.setic.ufsc.br:80/auth/v1.0/ POST -H "X-Auth-Token: AUTH_tkd2fb252ad93940b981b62865f4f8f8b8" -H "X-Account-Meta-Temp-Url-Key: 2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d"

# curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus -X GET -H "X-Auth-Token: AUTH_tkb39487498dad4ad1a792c261a64931ed"

# curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus -X GET -H "X-Auth-Token: AUTH_tkc9742d7a20e8444c93eb47d53164d527" -H "X-Account-Meta-Temp-Url-Key: 2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d"
# curl -i -k http://swift.setic.ufsc.br:80/v1/AUTH_unasus/unasus2.yoda%3B258_9/12814?temp_url_sig=0022345ada45dac6124b4aee034400efa999b7ae&temp_url_expires=1448557819 -X GET -H "X-Auth-Token: AUTH_tkb39487498dad4ad1a792c261a64931ed" -H "X-Account-Meta-Temp-Url-Key: 2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d"

# MessageEncryptor
#
# salt  = SecureRandom.random_bytes(64)
# key   = ActiveSupport::KeyGenerator.new('password').
#     generate_key(salt)
#
# message = "Encrypted string."
# encryptor = ActiveSupport::MessageEncryptor.new(key)
# # Encrypt the message...
# encrypted_message = encryptor.encrypt_and_sign(message)
# # and decrypt it.
# decrypted = encryptor.decrypt_and_verify(encrypted_message)
#
# # Decrypted message equals the original message
# decrypted == message #=> true

=begin

include ApplicationHelper
require 'fog'
#require 'openssl'
require 'redis'
require 'redis-namespace'

Excon.defaults[:ssl_verify_peer] = false
#Excon.defaults[:port] = 80
#Excon.defaults[:scheme] = 'http'

@auth_url     = 'http://swift.setic.ufsc.br:80/auth/v1.0/'
@user         = 'unasus:readwrite'
@password     = 'TccUnasus_2'

# @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935' }
# @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => '2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d' }
# @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key-2' => '2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d' }

# @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => '' }
@temp_url_key = '2cac0c77cc67a1ca4c264a90790fc033becc4465071c08f7eb818d6c5735722d'
@auth_token   = 'AUTH_tkb39487498dad4ad1a792c261a64931ed'

# swift_auth_url     : http://swift.setic.ufsc.br:80/auth/v1.0/

# 24 horas = 86400
# 1 hora = 3600
@seconds_URL_lives = 3600

#                            :openstack_auth_token => auth_token,
#                            :openstack_temp_url_key => @temp_url_key

@service = Fog::Storage.new(:provider => 'OpenStack', :openstack_auth_url => @auth_url, :openstack_username => @user, :openstack_api_key  => @password)

@redis_connection = Redis.new

moodle_id = '12814'
tcc = Tcc.find_by_student_id(438)

bt = BatchTccs.new(6);
remote_file = bt.open_last_pdf_tcc(tcc)
w_url = bt.generate_url(remote_file)

@namespaced_redis = Redis::Namespace.new(bt.name_space(tcc), :redis => @redis_connection)

tcc_updated_at = tcc.updated_at.to_s

rf = bt.open_last_pdf_tcc(moodle_id)

def temp_dir
    path = File.join(Rails.root, 'tmp', 'rails-latex', "#{Process.pid}-#{Thread.current.hash}")
    FileUtils.mkdir_p(path)
    path
end

#input = File.join(temp_dir, "#{moodle_id}.pdf")
input = File.join(temp_dir, "#{tcc.student.name}.pdf")
File.open(input, 'wb') { |io| io.write(rf.body) }

bt.generate_metalink2([12140,12141,12142,12143,12144])

bt.generate_metalink(tcc)

rf = bt.save_pdf_tcc(tcc)

url = bt.generate_pdf_url(tcc)

########################
moodle_id = '12140'
tcc = Tcc.find_by_student_id(439)

bt = BatchTccs.new;
bt.name_space(tcc)


t = Metalink::Metalink.new
t.add_file("#{tcc.student.name}.pdf", [{ :type => "http", :url => "#{bg.generate_url(tcc)}" }])
t.add_file("#{input}", [{ :type => "http", :url => "#{CGI.escapeHTML(bg.generate_url(tcc)+'&filename='+tcc.student.name+'.pdf')}" }])puts t.to_s

output = File.join(temp_dir, "tcc.metalink")
File.open(output, 'wb') { |io| io.write(t.to_s) }

@service.directories
dir =  @service.directories[0]
dir.files.each { |rf| rf.destroy}
 dir.destroy


pdf_service = PDFService.new(moodle_id)
pdf_stream = pdf_service.generate_pdf


#### instalar metalink do github local
bundle config local.metalink ~/metalink-ruby
gem 'metalink', :github => 'robertosilvino/metalink-ruby', :branch => 'add-binary-structure'

bundle config disable_local_branch_check true

    Excon.defaults[:ssl_verify_peer] = false
Excon.defaults[:port] = 80

=end

