class Api::V1::UsersController < ApplicationController

  def index
    @users = User.all 
    render json: @users.as_json(except: [:hashed_password, :salt])
  end
  
  def create
    requested_credit = params.dig(:user, :credit_balance) || params[:credit_balance]
    initial_credit = requested_credit.present? ? requested_credit.to_i : 50
    @user = User.new(user_params.merge(credit_balance: initial_credit)) 
    if @user.save
      render json: @user.as_json(except: [:hashed_password, :salt]), status: :created 
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user.as_json(except: [:hashed_password, :salt])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Kullanıcı bulunamadı." }, status: :not_found
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user.as_json(except: [:hashed_password, :salt]), status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Güncellenecek kullanıcı bulunamadı." }, status: :not_found
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek kullanıcı bulunamadı." }, status: :not_found
  end

  private

  def user_params
    permitted_keys = [
      :forename,
      :surname,
      :language,
      :role,
      :hashed_password,
      :credit_balance
    ]
    if params[:user].present?
      params.require(:user).permit(*permitted_keys)
    else
      params.permit(*permitted_keys)
    end
  end
end