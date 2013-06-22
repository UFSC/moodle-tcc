module InstructorAdminHelper
  def get_state(object)
    t('states.'+object.aasm_current_state.to_s)
  end

  def get_action(object)
    t('actions.'+object.aasm_current_state.to_s)
  end

  # @deprecated
  def get_hub_state(tcc, category)
    t('states.'+hub_state(tcc, category))
  end

  # @deprecated
  def get_hub_action(tcc, category)
    t('actions.'+hub_state(tcc, category))
  end

  private

  def hub_state(tcc, category)
    if hub = tcc.hubs.where(category: category).first
      hub.aasm_current_state.to_s
    else
      'draft'
    end
  end
end
