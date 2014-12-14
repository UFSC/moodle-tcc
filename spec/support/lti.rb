# encoding: utf-8
class FakeLTI

  attr_writer :tcc
  attr_writer :tool_consumer
  attr_writer :tool_provider
  attr_writer :user_id

  def initialize(roles: Authentication::Roles.student)
    @roles = roles
  end

  def lti_launch_data
    tool_consumer.generate_launch_data
  end

  def lti_session_data
    {'lti_launch_params' => lti_launch_data}
  end

  def tcc
    @tcc ||= Fabricate(:tcc_with_all)
  end

  def tool_consumer
    @tool_consumer ||= fake_tool_consumer
  end

  def tool_provider
    @tool_provider ||= fake_tool_provider
  end

  def user_id
    @user_id || tcc.student.moodle_id
  end

  private

  def default_params
    {
        'launch_url' => 'http://www.example.com/',
        'lis_outcome_service_url' => outcome_service_url,
        'resource_link_id' => 1,
        'roles' => @roles,
        'tool_consumer_instance_guid' => Settings.instance_guid,
        'user_id' => user_id,

        # custom params start with custom_:
        'custom_tcc_definition' => tcc.tcc_definition.id
    }
  end

  def fake_tool_consumer
    IMS::LTI::ToolConsumer.new(Settings.consumer_key, Settings.consumer_secret, default_params)
  end

  def fake_tool_provider
    IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_launch_data)
  end

  def outcome_service_url
    URI.parse(Settings.moodle_url).merge!('/mod/lti/service.php').to_s
  end
end

def moodle_lti_params_by_person(roles = 'student', person, tcc)
  fakelti = FakeLTI.new(roles: roles)
  fakelti.tcc = tcc
  fakelti.user_id = person.moodle_id

  fakelti.lti_launch_data
end

def moodle_lti_params(roles = 'student')
  fakelti = FakeLTI.new(roles: roles)
  fakelti.lti_launch_data
end

def fake_lti_session(roles = 'student')
  lti_params = moodle_lti_params(roles)
  #@tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_session_by_person(roles='student', person, tcc)
  lti_params = moodle_lti_params_by_person(roles, person, tcc)
  #@tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_tool_provider(roles = 'student')
  FakeLTI.new(roles: roles).tool_provider
end