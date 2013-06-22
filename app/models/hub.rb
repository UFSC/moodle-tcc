class Hub < ActiveRecord::Base

  belongs_to :tcc
  has_many :diaries

  # Mass-Assignment
  attr_accessible :category, :reflection, :commentary, :grade, :diaries_attributes

  accepts_nested_attributes_for :diaries

  include TccStateMachine
  validates :grade, :inclusion => { in: 0..10 }, if: :admin_evaluation_ok?

  has_paper_trail

  # Verifica se possui todos os diário associados a este eixo com algum tipo de conteúdo
  def filled_diaries?
    diaries.each do |d|
      return false if d.content.blank?
    end

    true
  end

end
