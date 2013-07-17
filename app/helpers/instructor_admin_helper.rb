module InstructorAdminHelper
  unloadable

  def get_state(object)
    t('states.'+object.aasm_current_state.to_s)
  end

  def get_action(object)
    t('actions.'+object.aasm_current_state.to_s)
  end

  def get_status_label(hub, moodle_user)
    state = hub.blank? ? 'blank' : hub.aasm_current_state

    text = t("states_label.#{state.to_s}")
    label_class = {draft: 'label-info', sent_to_admin_for_revision: 'label-warning',
                   sent_to_admin_for_evaluation: 'label-important', admin_evaluation_ok: 'label-success'}

    link_to(text, show_hubs_path(position: (hub.position), moodle_user: moodle_user), target: '_blank', class: "label #{label_class[state]}")
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
