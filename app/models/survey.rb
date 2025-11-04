class Survey < ApplicationRecord

  belongs_to :scale
  has_many :responses, dependent: :destroy 
  has_many :analyses, dependent: :destroy
  has_many :questions, dependent: :destroy

  validates :status, presence: true, inclusion: { in: %w(Draft Active Completed) }
  
  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank
  
  def distribute(mode)
    puts "#{mode} modunda dağıtım başlatılıyor."
  end
end
