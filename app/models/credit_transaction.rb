class CreditTransaction < ApplicationRecord

  belongs_to :user

  validates :cost, numericality: { greater_than: 0 }

  validates :activity_type, presence: true, inclusion: { 
    in: %w(ScaleDevelopment SurveyCreation DataCollection Analysis ReportGeneration Purchase) 
  } 


  after_create :log_transaction 

  def log_transaction
    puts "Kredi işlemi #{self.id} kaydedildi: #{self.activity_type} için #{self.cost} kredi."
  end
end