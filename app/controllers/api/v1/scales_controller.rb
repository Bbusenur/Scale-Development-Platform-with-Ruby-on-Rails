class Api::V1::ScalesController < ApplicationController
  SCALE_CREATION_COST = 15 

  def index
    # Sadece current_user'ın scales'ini göster
    @scales = current_user ? current_user.scales : []
    render json: @scales.map { |scale| format_scale(scale) }
  end

  def show
    @scale = Scale.find(params[:id])
    render json: format_scale(@scale)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ölçek bulunamadı." }, status: :not_found
  end

  def create
    # Token'dan user'ı al
    @user = current_user
    return render json: { error: "Unauthorized" }, status: :unauthorized unless @user

    unless @user.use_credits(SCALE_CREATION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Ölçek oluşturma maliyeti: #{SCALE_CREATION_COST} kredi.",
        current_balance: @user.credit_balance
      }, status: :payment_required 
    end

    # scale_params zaten :description ve :scale_type permit ediyor
    # Frontend'den scaleType geliyorsa scale_type'a dönüştür
    scale_attributes = scale_params.to_h
    
    # Frontend'den camelCase scaleType geliyorsa snake_case scale_type'a dönüştür
    if params[:scaleType].present?
      scale_attributes[:scale_type] = params[:scaleType]
    end
    
    @scale = @user.scales.new(scale_attributes)
    
    if @scale.save
      CreditTransaction.create(
        user: @user,
        cost: SCALE_CREATION_COST,
        activity_type: 'ScaleDevelopment',
        transaction_date: Time.current
      )
      render json: @scale, status: :created
    else
      render json: { errors: @scale.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Kullanıcı bulunamadı." }, status: :not_found
  end
  
  def update
    @scale = Scale.find(params[:id])
    
    if @scale.update(scale_params)
      render json: @scale, status: :ok
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Güncellenecek ölçek bulunamadı." }, status: :not_found
  end

  def destroy
    @scale = Scale.find(params[:id])
    
    # Sadece scale'in sahibi silebilir
    return render json: { error: "Unauthorized" }, status: :unauthorized unless current_user && @scale.user_id == current_user.id

    @scale.destroy! 
    
    head :no_content 
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek ölçek bulunamadı." }, status: :not_found
  end

  private

  def format_scale(scale)
    {
      id: scale.id,
      title: scale.title,
      description: scale.description,
      scaleType: scale.scale_type,
      version: scale.version,
      isPublic: scale.is_public,
      uniqueScaleId: scale.unique_scale_id,
      userId: scale.user_id,
      createdAt: scale.created_at,
      updatedAt: scale.updated_at
    }
  end
  
  def scale_params
    permitted_keys = [:title, :version, :is_public, :unique_scale_id, :user_id, :description, :scale_type]
    
    if params[:scale].present?
      params.require(:scale).permit(*permitted_keys)
    else
      params.permit(*permitted_keys)
    end
  end
end