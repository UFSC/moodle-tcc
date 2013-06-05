require 'spec_helper'

def moodle_oauth
  #todo: melhorar
  Capybara.current_driver = :rack_test
  page.driver.post tccs_path
  Capybara.use_default_driver
end

def moodle_lti_params(roles = 'student', type = 'portifolio')
  tc = IMS::LTI::ToolConsumer.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'])
  tc.launch_url = 'http://moodle.local/mod/lti/service.php'
  tc.resource_link_id = 1
  tc.roles = roles
  tc.user_id = 123
  tc.custom_params = { "type" => type }

  return tc.generate_launch_data
end

def fake_lti_session(roles = 'student', type = 'portifolio')
  { 'lti_launch_params' => moodle_lti_params(roles, type) }
end