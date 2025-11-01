class Analysis < ApplicationRecord
  belongs_to :survey

  STATUSES = %w[Queued Running Succeeded Failed].freeze

  validates :analysis_type, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end


