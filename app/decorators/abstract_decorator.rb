class AbstractDecorator < Draper::Decorator
  delegate_all

  def state_date
    return object.state_date.nil? ? object.created_at : object.state_date
  end

end