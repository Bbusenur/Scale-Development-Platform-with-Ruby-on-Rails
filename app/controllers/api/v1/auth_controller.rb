class Api::V1::AuthController < ApplicationController
  def signup
    # Frontend'den gelen name'i firstName ve lastName'e böl veya direkt firstName/lastName kullan
    first_name = params[:firstName] || params[:first_name] || extract_first_name(params[:name])
    last_name = params[:lastName] || params[:last_name] || extract_last_name(params[:name])
    
    user_params_hash = {
      forename: first_name,
      surname: last_name,
      language: params[:language] || 'en',
      role: params[:role] || 'user',
      credit_balance: params[:credit_balance] || 100,
      hashed_password: params[:password] # Basit hash için - production'da bcrypt kullanılmalı
    }
    
    @user = User.new(user_params_hash)
    
    if @user.save
      # Basit token üretimi (production'da JWT kullanılmalı)
      token = generate_token(@user)
      
      render json: {
        user: format_user(@user),
        token: token
      }, status: :created
    else
      render json: { 
        message: @user.errors.full_messages.join(', ') 
      }, status: :unprocessable_entity
    end
  end
  
  def login
    email_param = params[:email]
    password_param = params[:password]
    
    return render json: { message: 'Email and password are required' }, status: :unauthorized unless email_param.present? && password_param.present?
    
    # Sadece signup ile oluşturulan kullanıcıları kontrol et (hashed_password olanlar)
    # Tüm signup kullanıcılarını al ve password ile eşleşeni bul
    signup_users = User.where.not(hashed_password: [nil, ''])
    
    @user = signup_users.find do |user|
      # Basit password kontrolü - production'da bcrypt kullanılmalı
      # Şimdilik hashed_password ile direkt karşılaştırma yapıyoruz
      user.hashed_password == password_param
    end
    
    # Eğer password ile eşleşen kullanıcı bulunamadıysa, email parametresi ile forename eşleştirmesi yap
    if @user.nil? && email_param.present?
      potential_user = signup_users.find_by(forename: email_param)
      if potential_user && potential_user.hashed_password == password_param
        @user = potential_user
      end
    end
    
    if @user && @user.hashed_password.present?
      token = generate_token(@user)
      
      render json: {
        user: format_user(@user),
        token: token
      }, status: :ok
    else
      render json: { message: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  private
  
  def extract_first_name(name)
    return '' unless name.present?
    name.split(' ').first || ''
  end
  
  def extract_last_name(name)
    return '' unless name.present?
    parts = name.split(' ')
    parts.length > 1 ? parts[1..-1].join(' ') : ''
  end
  
  def generate_token(user)
    # Basit token - user ID'yi base64 encode ederek token'a ekliyoruz
    # Production'da JWT kullanılmalı
    token_data = "#{user.id}:#{Time.current.to_i}"
    Base64.urlsafe_encode64(token_data)
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

