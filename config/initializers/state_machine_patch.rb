# config/initializers/state_machine_patch.rb
# See https://github.com/pluginaweek/state_machine/issues/251
module StateMachine
  module Integrations
    module ActiveModel
      public :around_validation
    end
  end
end
