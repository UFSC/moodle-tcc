require 'spec_helper'

def moodle_oauth
  #todo: melhorar
  Capybara.current_driver = :rack_test
  page.driver.post tccs_path
  Capybara.use_default_driver
end