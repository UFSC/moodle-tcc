require 'spec_helper'

def moodle_lti_params(roles = 'student', type = 'portfolio')
  @tcc_definition ||= Fabricate(:tcc_definition)
  @tcc ||= Fabricate(:tcc, tcc_definition: @tcc_definition)
  3.times do |i|
    hub_definition = Fabricate(:hub_definition, title: 'Eixo '+(i+1).to_s, position: i+1, tcc_definition: @tcc_definition)
  end

  tc = IMS::LTI::ToolConsumer.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'])
  tc.launch_url = 'http://moodle.local/mod/lti/service.php'
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = 123
  tc.custom_params = {
      'type' => type,
      'tcc_definition' => @tcc_definition.id
  }

  tc.generate_launch_data
end

def fake_lti_session(roles = 'student', type = 'portfolio')
  {'lti_launch_params' => moodle_lti_params(roles, type)}
end

def fake_lti_tp(roles = 'student', type = 'portfolio')
  IMS::LTI::ToolProvider.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'], moodle_lti_params(roles, type))
end