class Api::V1::CreditTransactionsController < ApplicationController

  def index
    @user = User.first 
    
    # Kullanıcının en son işlemlerini listele
    @transactions = @user.credit_transactions.order(transaction_date: :desc)
    
    render json: @transactions
  end
end