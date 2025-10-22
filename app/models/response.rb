class Response < ApplicationRecord

  belongs_to :survey
  
  

  def validate_data
    
    puts "INFO: Running automated quality checks and error identification for response ID #{self.id}"
    
  end

  def clean_data
    
  end
end