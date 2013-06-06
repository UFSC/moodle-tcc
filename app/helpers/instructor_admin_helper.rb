module InstructorAdminHelper
  def get_state(object)
    t('states.'+object.state)
  end

  def get_action(object)

  end

  def get_hub_state(tcc, category)
    t('states.'+hub_state(tcc, category))
  end

  def get_hub_action(tcc, category)
    t('actions.'+hub_state(tcc, category))
  end

  private

  def hub_state(tcc, category)
    if hub = tcc.hubs.where(category: category).first
      hub.state
    else
      'draft'
    end
  end
end
