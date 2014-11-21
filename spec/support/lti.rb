# encoding: utf-8
require 'spec_helper'

def moodle_lti_params_by_person(roles = 'student', person, tcc)
  tc = IMS::LTI::ToolConsumer.new(Settings.consumer_key, Settings.consumer_secret)
  begin
    tc.launch_url = root_url
  rescue
    tc.launch_url = "http://www.example.com/"
  end
  tc.lis_outcome_service_url = URI.parse(Settings.moodle_url).merge!('/mod/lti/service.php').to_s
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = person.moodle_id
  tc.tool_consumer_instance_guid = Settings.instance_guid
  if (!tcc.nil?)
    tc.custom_params = {
      'tcc_definition' => tcc.tcc_definition.id
    }
  end
  tc.generate_launch_data
end

def moodle_lti_params(roles = 'student')
  @tcc ||= Fabricate(:tcc_with_all)
  tc = IMS::LTI::ToolConsumer.new(Settings.consumer_key, Settings.consumer_secret)
  begin
    tc.launch_url = root_url
  rescue
    tc.launch_url = "http://www.example.com/"
  end
  tc.lis_outcome_service_url = URI.parse(Settings.moodle_url).merge!('/mod/lti/service.php').to_s
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = @tcc.student.moodle_id
  tc.tool_consumer_instance_guid = Settings.instance_guid
  tc.custom_params = {
      'tcc_definition' => @tcc.tcc_definition.id
  }

  @tcc.save! unless @tcc.changed?

  tc.generate_launch_data
end

def fake_lti_session(roles = 'student')
  lti_params = moodle_lti_params(roles)
  @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_session_by_person(roles='student', person, tcc)
  lti_params = moodle_lti_params_by_person(roles, person, tcc)
  @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)

  {'lti_launch_params' => lti_params}
end

def fake_lti_tp(roles = 'student')
  IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, moodle_lti_params(roles))
end