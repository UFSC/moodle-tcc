# encoding: utf-8
require 'fog'

class InstructorAdminController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_action :get_tcc
  before_action :check_permission


  def salva_servidor(tcc)

    def open_directory(directoryName)
      # To retrieve a list of directories:
      # service.directories

      directory = @service.directories.get(directoryName)
      if directory == nil
        directory = @service.directories.create :key => directoryName
      end
      directory
    end

    # curl -i https://swift.setic.ufsc.br:8080/auth/v1.0/ \ -H "X-Auth-User: unasus:readwrite" -H "X-Auth-Key: TccUnasus_2"
    # st.request :method => 'GET', :headers => { 'X-Account-Meta-Quota-Bytes' => '1048576' }

    # st.request :method => 'HEAD'

    credentials['X-Auth-Token']

    # Temporary URL
    #
    # http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html

    # curl -i -k https://swift.setic.ufsc.br:8080/auth/v1.0/  -H "X-Auth-User: unasus:readwrite" -H "X-Auth-Key: TccUnasus_2"
    # AUTH_tkd2fb252ad93940b981b62865f4f8f8b8
    # curl -i -k https://swift.setic.ufsc.br:8080/v1/AUTH_unasus/tcc92_1/Acir%20Henrique%20Truppel%20%28201405050%29 -X GET -H "X-Auth-Token: AUTH_tkd2fb252ad93940b981b62865f4f8f8b8" > /tmp/xxx.pdf

    #TODO: atividades no Swift
    # criar um usuário para somente teitura
    # configurar sessão com timeout de um dia


    puts('1 -------- inicio')

    auth_url = 'https://swift.setic.ufsc.br:8080/auth/v1.0/'
    user = 'unasus:readwrite'
    password = 'TccUnasus_2'


    Excon.defaults[:ssl_verify_peer] = false


    # TbOSfJ6uOCA8Yk7JTCt5272E0i1j57io
    Fog::OpenStack.authenticate_v1({:openstack_auth_uri => auth_url,
                                    :openstack_api_key => user,
                                   :openstack_username =>password})

    #
    # We are going to use the Identity (Keystone) service
    # to retrieve the list of tenants available and find
    # the tenant we want to set the quotas for.
    #
    id = Fog::Storage.new({ :provider => 'OpenStack',
                            :openstack_auth_url => auth_url,
                            :openstack_username => user,
                            :openstack_api_key  => password})

    #
    # Storage service (Swift)
    #
    @service = Fog::Storage.new :provider => 'OpenStack',
                          :openstack_auth_url => auth_url,
                          :openstack_username => user,
                          :openstack_api_key  => password,
                          :openstack_temp_url_key => 'TbOSfJ6uOCA8Yk7JTCt5272E0i1j57io'
    if @service != nil

      #response = service.head_containers
      #response.status

      directory = open_directory('tcc92_t')

      file = directory.files.create(:key  => tcc.student.name,
                                    :body => File.open("tmp/#{tcc.student.name}.pdf"),
                                    )

      # file = directory.files.get("key")
      # puts file.public_url

      # Download files
      #================
      # File.open('downloaded-file.jpg', 'w') do | f |
      #   directory.files.get("my_big_file.jpg") do | data, remaining, content_length |
      #     f.syswrite data
      #   end
      # end


      # OpenStack DocumentationTemporary URL middleware
      # http://docs.openstack.org/api/openstack-object-storage/1.0/content/tempurl.html

      # st.request :method => 'POST', :headers => { 'X-Account-Meta-Temp-URL-Key' => 'TbOSfJ6uOCA8Yk7JTCt5272E0i1j57io' }

      # Create TempURL (in Ruby)
      #
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

    end
    puts('999 ------ fim')
  end

  def index
    authorize(Tcc, :show_scope?)
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(@tcc_definition)

    search_options = {eager_load: [:abstract, :tcc_definition]}
    @tccs = tccs.search(params[:search], params[:page], search_options).includes(:orientador)

    @chapters = @tcc_definition.chapter_definitions.map { |h| h.title }
  end

  def autocomplete_tcc_name
    term = params[:term]

    tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(tcc_definition)

    @tccs = tccs.search(term, 0)

    render :json => @tccs.map { |tcc| {:id => tcc.id, :label => tcc.student.name, :value => tcc.student.name} }
  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

  def tcc_searchable(tcc_definition)
    tccList = Tcc.includes(:student, chapters: [:chapter_definition]).where(tcc_definition_id: tcc_definition.id)
    policy_scope(tccList)
  end


end
