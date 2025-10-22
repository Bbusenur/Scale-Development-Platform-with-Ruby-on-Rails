class Api::V1::ScalesController < ApplicationController
  # SDP Kuralı: Ölçek geliştirme maliyeti 15 Kredi (10-20 aralığından)
  SCALE_CREATION_COST = 15 


  def index
    # Tüm ölçekleri listeler
    @scales = Scale.all 
    render json: @scales
  end


  def create
    #  Kullanıcıyı bul
    # Gelen isteğin user_id'sini kullanarak ilgili User kaydını bulur
    @user = User.find(scale_params[:user_id]) 
    
    #  Kredi kontrolü ve düşürme işlemi
    # use_credits metodu true/false döndürür ve bakiye yeterliyse düşürür.
    unless @user.use_credits(SCALE_CREATION_COST) 
      # Kredi yetersizse, işlemi hemen keser ve 402 HATA KODU döndürür.
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Ölçek oluşturma maliyeti: #{SCALE_CREATION_COST} kredi.",
        current_balance: @user.credit_balance
      }, status: :payment_required 
    end

    # 3. Ölçek kaydını oluştur (Kredi düşürüldü, şimdi kaydı yap)
    @scale = @user.scales.new(scale_params)
    
    if @scale.save
      # 4. İşlem kaydını oluştur (Raporlama ve takip için)
      CreditTransaction.create(
        user: @user,
        cost: SCALE_CREATION_COST,
        activity_type: 'ScaleDevelopment',
        transaction_date: Time.current
      )
      

      render json: @scale, status: :created
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  end
  
  def run_validation
    @scale = Scale.find(params[:id])
    @scale.run_ai_validation 
    render json: { message: "AI destekli doğrulama başlatıldı.", validated_at: @scale.last_validated_at }
  end


  def show
    @scale = Scale.find(params[:id])
    render json: @scale
  end
#  Silme
  def destroy
    @scale = Scale.find(params[:id])

    @scale.destroy! 
    
    head :no_content 
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek ölçek bulunamadı." }, status: :not_found
  end
  private
  

  def scale_params
    params.require(:scale).permit(:title, :version, :is_public, :unique_scale_id, :user_id) 
  end
end