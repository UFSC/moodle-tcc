class Comment < ActiveRecord::Base

  # Virtual attributes
  attr_accessor :hub_grade

  # Mass-Assignment
  attr_accessible :commentable_id, :commentable_type, :content, :version_id, :hub_grade

  belongs_to :commentable, :polymorphic => true
end
