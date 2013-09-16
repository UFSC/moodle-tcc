class HubPortfolio < Hub

  validates :grade, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, if: :admin_evaluation_ok?
end