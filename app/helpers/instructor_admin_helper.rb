module InstructorAdminHelper
  def get_state(object)
    t('states.'+object.aasm_current_state.to_s)
  end

  def get_action(object)
    t('actions.'+object.aasm_current_state.to_s)
  end

  private

  def hub_state(tcc, position)
    if hub = tcc.hubs.where(position: position).first
      hub.aasm_current_state.to_s
    else
      'draft'
    end
  end
end
