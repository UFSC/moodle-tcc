class HubPortfolio < Hub
  # TODO: migrar para um decorator
  def show_grade?
    self.admin_evaluation_ok? || self.terminated?
  end

  # TODO: migrar para um decorator
  def show_title?
    false
  end
end