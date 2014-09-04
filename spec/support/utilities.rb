# encoding: utf-8
require 'spec_helper'

def moodle_lti_params(roles = 'student', type = 'portfolio')
  @tcc ||= Fabricate(:tcc_with_all)

  tc = IMS::LTI::ToolConsumer.new(Settings.consumer_key, Settings.consumer_secret)
  tc.launch_url = URI.parse(Settings.moodle_url).merge!('/mod/lti/service.php').to_s
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = @tcc.student.moodle_id
  tc.tool_consumer_instance_guid = Settings.instance_guid
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
  IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, moodle_lti_params(roles, type))
end