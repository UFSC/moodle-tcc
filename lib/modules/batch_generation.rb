require 'fog'
require 'openssl'

class BatchGeneration

  def initialize
    @auth_url = 'https://swift.setic.ufsc.br:8080/auth/v1.0/'
    @user = 'unasus:readwrite'
    @password = 'TccUnasus_2'
    @temp_url_key = 'f8ad7c9118a28d9a7e6413435620b9208149d0996a9831823ea3f2739e82e935'
    #@temp_url_key2 = SecureRandom.hex(32).to_s
    @auth_token = 'AUTH_tkd2fb252ad93940b981b62865f4f8f8b8'
    @seconds_URL_lives = 86400
    # 1 hora = 3600

    Excon.defaults[:ssl_verify_peer] = false

    # Temporary URL
    #
    # http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html

    # curl -i -k https://swift.setic.ufsc.br:8080/auth/v1.0/  -H "X-Auth-User: unasus:readwrite" -H "X-Auth-Key: TccUnasus_2"
    # AUTH_tkd2fb252ad93940b981b62865f4f8f8b8
    # curl -i -k https://swift.setic.ufsc.br:8080/v1/AUTH_unasus/tcc92_1/Acir%20Henrique%20Truppel%20%28201405050%29 -X GET -H "X-Auth-Token: AUTH_tkd2fb252ad93940b981b62865f4f8f8b8" > /tmp/xxx.pdf

    @service = Fog::Storage.new :provider => 'OpenStack',
                               :openstack_auth_url => @auth_url,
                               :openstack_username => @user,
                               :openstack_api_key  => @password
#                                :openstack_auth_token => auth_token,
#                               :openstack_temp_url_key => @temp_url_key
  end

  def temp_url_key
    @temp_url_key
  end

  def save_tcc(moodle_id)
    student = Person.find_by_moodle_id(moodle_id)
    tcc = Tcc.find_by_student_id (student.id)

    puts('1 -------- inicio')

    if @service != nil
      #response = service.head_containers
      #response.status

      directory = open_directory('tcc92_t')

      pdf_service = PDFService.new(moodle_id)
      puts("Starting the TCC print: #{moodle_id} - #{pdf_service.tcc.student.name}")

      # pdfTex = pdf_service.generate_tex
      # File.open(filename(pdf_service.tcc.student.name,'tex'), 'w+') do |f|
      #   f.write(pdfTex)
      # end

      pdfStream = pdf_service.generate_pdf
      puts("Ending the TCC print: #{moodle_id} - #{pdf_service.tcc.student.name}")

      puts("Saving TCC in file: #{moodle_id} - #{pdf_service.tcc.student.name}")

      input = File.join(temp_dir, "#{moodle_id}.pdf")
      File.open(input, 'wb') { |io| io.write(pdfStream) }
      tmpPdfFile = File.open(input, 'r+')
      remoteFile = directory.files.create( :key  => "#{moodle_id}", :body => tmpPdfFile, :public => true )
      remoteFile
    end

  end

  def generate_url(remote_file)
    generate_signature('GET', remote_file.public_url, @seconds_URL_lives, @temp_url_key )
  end

  private

  def generate_signature(method, url, seconds, key)

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
    method = method.upcase
    base_url, object_path = url.split(/\/v1\//)
    object_path = '/v1/' + object_path
    seconds = seconds.to_i
    expires = (Time.now + seconds).to_i
    hmac_body = "#{method}\n#{expires}\n#{object_path}"
    sig = OpenSSL::HMAC.hexdigest("sha1", key, hmac_body)
    puts ("#{base_url}#{object_path}?" +
             "temp_url_sig=#{sig}&temp_url_expires=#{expires}")
    sig
    # end
  end

  def temp_dir
    path = File.join(Rails.root, 'tmp', 'rails-latex', "#{Process.pid}-#{Thread.current.hash}")
    FileUtils.mkdir_p(path)

    path
  end

  def open_directory(directoryName)
    # To retrieve a list of directories:
    # service.directories

    directory = @service.directories.get(directoryName)
    if directory == nil
      directory = @service.directories.create :key => directoryName
    end
    directory
  end

end

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
#
# File.open('/temp/tccs.metalink', 'w+') do |f|  f.write(t.to_s) end
# abrir arquivo com (botão da direita sobre arquivo) firefox
# selecionar opção "dTa OneClick!"



#http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
# Create TempURL (in Ruby)

# http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
#
# http://docs.rackspace.com/files/api/v1/cf-devguide/content/TempURL-d1a4450.html
#

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
