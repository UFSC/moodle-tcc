require 'spec_helper'

def moodle_lti_params(roles = 'student', type = 'portfolio')
  @tcc ||= Fabricate(:tcc_with_all)

  tc = IMS::LTI::ToolConsumer.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'])
  tc.launch_url = 'http://moodle.local/mod/lti/service.php'
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = @tcc.moodle_user
  tc.tool_consumer_instance_guid = 'localhost'
  tc.custom_params = {
      'type' => type,
      'tcc_definition' => @tcc.tcc_definition.id
  }

  tc.generate_launch_data
end

def fake_lti_session(roles = 'student', type = 'portfolio')
  {'lti_launch_params' => moodle_lti_params(roles, type)}
end

def fake_lti_tp(roles = 'student', type = 'portfolio')
  IMS::LTI::ToolProvider.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'], moodle_lti_params(roles, type))
end