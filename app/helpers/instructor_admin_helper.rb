module InstructorAdminHelper
  unloadable

  STATUS_LABEL_CLASSES = {draft: 'label-info', sent_to_admin_for_revision: 'label-warning',
                          sent_to_admin_for_evaluation: 'label-important', admin_evaluation_ok: 'label-success',
                          terminated: 'label-success'}

  def action_label(object, link_to_path)
    state = object.blank? ? 'new' : object.aasm_current_state

    if object.nil?
      content_tag('span', label_text('actions', state), class: status_label_class(state))
    else
      link_to(label_text('actions', state), link_to_path, target: '_blank', class: status_label_class(state))
    end
  end

  def hub_status_label(hub, moodle_user)
    state = hub.blank? ? 'blank' : hub.aasm_current_state

    link_to label_text('states_label', state),
            show_hubs_path(position: (hub.position), moodle_user: moodle_user),
            target: '_blank', class: status_label_class(state)
  end

  private

  def status_label_class(state)
    "label #{STATUS_LABEL_CLASSES[state]}"
  end

  def label_text(type, state)
    t(type+'.'+state.to_s)
  end
end
