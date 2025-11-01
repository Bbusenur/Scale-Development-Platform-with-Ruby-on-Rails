class Survey < ApplicationRecord

  belongs_to :scale
  has_many :responses, dependent: :destroy 
  has_many :analyses, dependent: :destroy

  validates :status, presence: true, inclusion: { in: %w(Draft Active Completed) }
  
  def distribute(mode)
    puts "#{mode} modunda dağıtım başlatılıyor."
  end
end
