# encoding: utf-8
class FakeLTI

  attr_writer :tcc
  attr_writer :tool_consumer
  attr_writer :tool_provider
  attr_writer :user_id

  def initialize(roles: Authentication::Roles.student, show_graded_after: nil, show_graded_before: nil)
    @roles = roles
    @show_graded_after = show_graded_after
    @show_graded_before = show_graded_before
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


    params = {
        'launch_url' => 'http://www.example.com/',
        'lis_outcome_service_url' => outcome_service_url,
        'resource_link_id' => 1,
        'roles' => @roles,
        'tool_consumer_instance_guid' => Settings.instance_guid,
        'user_id' => user_id,

        # custom params start with custom_:
        'custom_tcc_definition'     => tcc.tcc_definition.id
    }

    params.merge!({'custom_show_graded_after'  => @show_graded_after}) unless @show_graded_after.nil?
    params.merge!({'custom_show_graded_before' => @show_graded_before}) unless @show_graded_before.nil?

    params
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

# def moodle_lti_params_by_person(roles = 'student', person, tcc)
#   fakelti = FakeLTI.new(roles: roles)
#   fakelti.tcc = tcc
#   fakelti.user_id = person.moodle_id
#   fakelti.lti_launch_data
# end

def moodle_lti_params_by_person(roles = 'student', person, tcc, show_graded_after, show_graded_before)
  fakelti = FakeLTI.new(roles: roles, show_graded_after: show_graded_after, show_graded_before: show_graded_before)
  fakelti.tcc = tcc
  fakelti.user_id = person.moodle_id

  fakelti.lti_launch_data
end

def moodle_lti_params(roles = 'student', show_graded_after = nil, show_graded_before = nil)
  fakelti = FakeLTI.new(roles: roles, show_graded_after: show_graded_after, show_graded_before: show_graded_before)
  fakelti.lti_launch_data
end

def fake_lti_session(roles = 'student', show_graded_after = nil, show_graded_before = nil)
  lti_params = moodle_lti_params(roles, show_graded_after, show_graded_before)
  @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_session_by_person(roles='student', person, tcc)
  lti_params = moodle_lti_params_by_person(roles, person, tcc, nil, nil)
  @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_session_by_person_graded(roles='student', person, tcc, show_graded_after, show_graded_before)
  lti_params = moodle_lti_params_by_person(roles, person, tcc, show_graded_after, show_graded_before)
  @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_tool_provider(roles = 'student', show_graded_after = nil, show_graded_before = nil)
  FakeLTI.new(roles: roles, show_graded_after: show_graded_after, show_graded_before: show_graded_before).tool_provider
end