# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  # Bu sınıfa, kullanıcı kimlik doğrulama (authentication) ve yetkilendirme (authorization)
  # gibi tüm kontrolcülerde ortak olacak mantık eklenir.

  # Token'dan user bulma
  def current_user
    @current_user ||= find_user_from_token
  end

  private

  def find_user_from_token
    auth_header = request.headers['Authorization']
    return nil unless auth_header
    
    # "Bearer token" veya sadece "token" formatını destekle
    token = auth_header.split(' ').last
    return nil unless token.present?
    
    begin
      # Base64 decode - padding ekleme
      # Base64.urlsafe_decode64 padding gerektirebilir
      padding_needed = (4 - token.length % 4) % 4
      token_with_padding = token + ('=' * padding_needed)
      
      # Önce padding ile dene
      decoded = begin
        Base64.urlsafe_decode64(token_with_padding)
      rescue ArgumentError
        # Padding olmadan dene
        Base64.urlsafe_decode64(token)
      end
      
      # Token formatı: "user_id:timestamp"
      parts = decoded.split(':')
      return nil if parts.empty? || parts.first.empty?
      
      user_id = parts.first.to_i
      return nil if user_id <= 0
      
      user = User.find_by(id: user_id)
      
      if user.nil?
        Rails.logger.warn "User not found with ID: #{user_id}"
      end
      
      user
    rescue ArgumentError => e
      # Base64 decode hatası - token formatı yanlış veya padding sorunu
      Rails.logger.error "Token decode error (ArgumentError): #{e.message}"
      Rails.logger.error "Token sample: #{token[0..30]}..."
      nil
    rescue => e
      Rails.logger.error "Token decode error: #{e.class.name}: #{e.message}"
      nil
    end
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: "Geçersiz istek: eksik veya hatalı gövde.", details: e.message }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Kayıt bulunamadı.", details: e.message }, status: :not_found
  end
end
