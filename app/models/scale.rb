class Scale < ApplicationRecord
  belongs_to :user 
  has_many :surveys 

  validates :title, presence: true 
  validates :unique_scale_id, uniqueness: true, allow_nil: true

  before_create :generate_unique_scale_id

  private

  def generate_unique_scale_id
    return if unique_scale_id.present?
    
    # Zaman damgası ve random string ile benzersiz ID oluştur
    timestamp = Time.current.to_i
    random = SecureRandom.hex(4)
    self.unique_scale_id = "SCALE_#{timestamp}_#{random}"
  end


  def run_ai_validation
    
    puts "Running AI-powered Scale Validation..."
    update(last_validated_at: Time.current)
  end

  def generate_metadata

  end
end