class Api::V1::UsersController < ApplicationController

  def index
    # Sadece admin tarafından oluşturulan kullanıcıları döndür
    # (hashed_password olmayan kullanıcılar - signup ile oluşturulmayanlar)
    @users = User.where("hashed_password IS NULL OR hashed_password = ''")
    render json: @users.map { |u| format_user(u) }
  end
  
  def create
    # Frontend'den firstName/lastName geliyor, forename/surname'e dönüştür
    # Admin tarafından oluşturulan kullanıcılar - hashed_password olmadan oluşturulur
    user_data = user_params.to_h
    user_data[:forename] = params[:firstName] || params[:forename]
    user_data[:surname] = params[:lastName] || params[:surname]
    user_data[:credit_balance] ||= 100
    # Admin tarafından oluşturulan kullanıcıların hashed_password'ü olmamalı
    user_data[:hashed_password] = nil
    
    @user = User.new(user_data)
    
    if @user.save
      render json: format_user(@user), status: :created 
    else
      render json: { message: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: format_user(@user)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Kullanıcı bulunamadı." }, status: :not_found
  end

  def update
    @user = User.find(params[:id])
    
    # Debug: Gelen parametreleri logla
    Rails.logger.debug "Update params received: #{params.inspect}"
    
    # user_params ile permitted parametreleri al
    permitted = user_params.to_h
    
    Rails.logger.debug "Permitted params: #{permitted.inspect}"
    
    # Frontend'den gelen firstName/lastName'i forename/surname'e dönüştür
    update_params = {}
    update_params[:forename] = permitted[:firstName] || permitted[:forename] if (permitted[:firstName].present? || permitted[:forename].present?)
    update_params[:surname] = permitted[:lastName] || permitted[:surname] if (permitted[:lastName].present? || permitted[:surname].present?)
    
    # Language ve role için - parametre gönderildiyse güncelle
    if permitted.key?(:language)
      update_params[:language] = permitted[:language]
    end
    if permitted.key?(:role)
      update_params[:role] = permitted[:role]
    end
    
    # Hashed_password ve credit_balance güncellenmemeli
    update_params.delete(:hashed_password)
    update_params.delete(:credit_balance)
    
    Rails.logger.debug "Update params to apply: #{update_params.inspect}"
    
    if update_params.empty?
      # Eğer hiçbir parametre yoksa, mevcut kullanıcıyı döndür
      render json: format_user(@user), status: :ok
    elsif @user.update(update_params)
      render json: format_user(@user), status: :ok
    else
      render json: { message: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
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
  
  def profile
    # Token'dan user'ı bul
    @user = current_user
    if @user
      render json: format_user(@user)
    else
      render json: { error: "Kullanıcı bulunamadı." }, status: :unauthorized
    end
  end

  private

  def user_params
    permitted_keys = [
      :forename,
      :surname,
      :firstName,
      :lastName,
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
  
  def format_user(user)
    {
      id: user.id,
      firstName: user.forename,
      lastName: user.surname,
      language: user.language,
      role: user.role,
      creditBalance: user.credit_balance
    }
  end
end