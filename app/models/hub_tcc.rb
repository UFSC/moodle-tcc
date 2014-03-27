class HubTcc < Hub

  include HubTccStateMachine

  # Estados para combo
  enumerize :new_state, in: aasm.states

  validates :reflection, presence: true, unless: Proc.new { |hub| hub.new? or hub.draft? }

  # TODO: migrar para um decorator
  def show_grade?
    false
  end

  # TODO: migrar para um decorator
  def show_title?
    true
  end
end