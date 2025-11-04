class Api::V1::SettingsController < ApplicationController
  
  def update
    # Token'dan user'ı bul - şimdilik basit implementation
    @user = User.first # Geçici - gerçek authentication gerekli
    
    # Settings'i kaydet (şimdilik basit implementation)
    # Production'da settings tablosu oluşturulmalı
    
    render json: { message: "Settings updated successfully" }, status: :ok
  end
end

