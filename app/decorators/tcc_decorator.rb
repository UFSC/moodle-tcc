class TccDecorator < Draper::Decorator
  delegate_all
  decorates_association :abstract
  decorates_association :chapters
end