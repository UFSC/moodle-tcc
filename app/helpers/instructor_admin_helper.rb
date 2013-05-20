module InstructorAdminHelper
  def get_state(tcc, category)
    t('states.'+state(tcc, category))
  end

  def get_action(tcc, category)
    t('actions.'+state(tcc, category))
  end

  private

  def state(tcc, category)
    if hub = tcc.hubs.where(category: category).first
      hub.state
    else
      'draft'
    end
  end
end
