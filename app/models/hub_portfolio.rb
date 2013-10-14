class HubPortfolio < Hub

  include HubStateMachine

  # Estados para combo
  enumerize :new_state, in: aasm_states

  validates :grade, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, if: :admin_evaluation_ok?
  validates :reflection, presence: true, unless: Proc.new { |hub| hub.new? or hub.draft? }

  def show_grade?
    self.admin_evaluation_ok? || self.terminated?
  end
end