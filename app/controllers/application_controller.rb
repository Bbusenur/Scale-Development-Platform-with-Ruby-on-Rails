# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  # Bu sınıfa, kullanıcı kimlik doğrulama (authentication) ve yetkilendirme (authorization)
  # gibi tüm kontrolcülerde ortak olacak mantık eklenir.

  # Örneğin: JWT ile kullanıcı kimliğini doğrulama metotları.
  # def authenticate_user!
  #   # ... JWT kontrol mantığı ...
  # end
end
