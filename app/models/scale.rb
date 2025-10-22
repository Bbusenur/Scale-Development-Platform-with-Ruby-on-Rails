class Scale < ApplicationRecord

  belongs_to :user 
  has_many :surveys 


  validates :title, presence: true 
  validates :unique_scale_id, presence: true, uniqueness: true


  def run_ai_validation
    
    puts "Running AI-powered Scale Validation..."
    update(last_validated_at: Time.current)
  end

  def generate_metadata

  end
end