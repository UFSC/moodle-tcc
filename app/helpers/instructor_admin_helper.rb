module InstructorAdminHelper
  unloadable

  STATUS_LABEL_CLASSES = {draft: 'label-info', sent_to_admin_for_revision: 'label-warning',
                          sent_to_admin_for_evaluation: 'label-important', admin_evaluation_ok: 'label-success',
                          terminated: 'label-success'}

  # @deprecated
  def get_state(object)
    t('states.'+object.aasm_current_state.to_s)
  end

  # @deprecated
  def get_action(object)
    t('actions.'+object.aasm_current_state.to_s)
  end

  def status_label(object, link_to_path)
    state = object.blank? ? 'blank' : object.aasm_current_state

    if object.nil?
      content_tag('span', status_label_text(state), class: status_label_class(state))
    else
      link_to(status_label_text(state), link_to_path, target: '_blank', class: status_label_class(state))
    end
  end

  def hub_status_label(hub, moodle_user)
    state = hub.blank? ? 'blank' : hub.aasm_current_state

    link_to(status_label_text(state), show_hubs_path(position: (hub.position), moodle_user: moodle_user), target: '_blank', class: status_label_class(state))
  end

  private
  def status_label_text(state)
    t("states_label.#{state.to_s}")
  end

  def status_label_class(state)
    "label #{STATUS_LABEL_CLASSES[state]}"
  end
end
