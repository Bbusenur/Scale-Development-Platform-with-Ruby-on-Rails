class User < ApplicationRecord
 
  has_many :scales 
  has_many :credit_transactions

  # Kredi bakiyesinin 0 veya pozitif olmasını zorunlu kılar
  validates :credit_balance, numericality: { greater_than_or_equal_to: 0 }
  
  # Kredi Düşürme İşlemi
  
  def use_credits(cost)
    if self.credit_balance >= cost
      self.credit_balance -= cost
      save # Veritabanında bakiyeyi günceller
      return true
    else
      return false
    end
  end
end