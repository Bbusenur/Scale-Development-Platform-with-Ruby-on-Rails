class Api::V1::CreditTransactionsController < ApplicationController

  def index
    @user = User.first 
    
    # Kullanıcının en son işlemlerini listele
    @transactions = @user.credit_transactions.order(transaction_date: :desc)
    
    render json: @transactions
  end
  
  def balance
    # Token'dan user'ı bul
    @user = current_user
    if @user
      render json: { balance: @user.credit_balance || 0 }
    else
      render json: { balance: 0 }
    end
  end
end