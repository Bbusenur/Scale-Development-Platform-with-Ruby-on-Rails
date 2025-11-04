class Question < ApplicationRecord
  belongs_to :survey

  validates :text, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[text multiple_choice checkbox rating scale] }
  validates :order, presence: true

  default_scope { order(:order) }
end

