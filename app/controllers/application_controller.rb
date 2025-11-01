# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  # Bu sınıfa, kullanıcı kimlik doğrulama (authentication) ve yetkilendirme (authorization)
  # gibi tüm kontrolcülerde ortak olacak mantık eklenir.

  # Örneğin: JWT ile kullanıcı kimliğini doğrulama metotları.
  # def authenticate_user!
  #   # ... JWT kontrol mantığı ...
  # end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: "Geçersiz istek: eksik veya hatalı gövde.", details: e.message }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Kayıt bulunamadı.", details: e.message }, status: :not_found
  end
end
