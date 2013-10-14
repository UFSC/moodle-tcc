class HubTcc < Hub

  include HubTccStateMachine

  # Estados para combo
  enumerize :new_state, in: aasm_states

  validates :reflection, presence: true, unless: Proc.new { |hub| hub.new? or hub.draft? }

  def show_grade?
    false
  end
end