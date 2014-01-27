module Shared::Validations
  extend ActiveSupport::Concern

  class CompleteNameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.nil? || value.blank?
        unless value.split(' ').size > 1
          record.errors[attribute] << I18n.t('is_not_complete_name')
        end
      end
    end
  end
end