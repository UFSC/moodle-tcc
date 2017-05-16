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
    begin
      @auth_url     = Settings.swift_auth_url
    rescue
      @auth_url     = ''
    end

    begin
      @user     = Settings.swift_user
      @password = Settings.swift_password
    rescue
      @user     = ''
      @password = ''
    end

    begin
      @temp_url_key = Settings.swift_temp_url_key
      @auth_token   = get_auth_token
    rescue
      @temp_url_key = ''
      @auth_token   = ''
    end

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
#                                  :headers => { 'X-Account-Meta-Temp-URL-Key' => self.temp_url_key },
                                  :openstack_api_key  => @password
#                                  :connection_options  => {:port => 80, :scheme =>  'http'}
      )
    rescue
      @service = nil
      raise '>>> OpenStack não pode ser aberto! Verifique a configuração: tcc_config.yml(auth_url, user, password).'
    end
    # seta a chave de URL temporária!
    # @service.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => self.temp_url_key }
    @service.post_set_meta_temp_url_key self.temp_url_key

    logger.debug('OK <<<')

    logger.info('+++ Inicialização do worker finalizada <<<')
  end

  def temp_url_key
    @temp_url_key
  end

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

    Mailer.tccs_batch_print(name, mail_to, metalink_file, activity_url).deliver_now unless mail_to.blank? || mail_to.nil?

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
