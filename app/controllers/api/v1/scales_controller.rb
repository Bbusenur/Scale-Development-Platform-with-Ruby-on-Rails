class Api::V1::ScalesController < ApplicationController
  SCALE_CREATION_COST = 15 

  def index
    @scales = Scale.all 
    render json: @scales
  end

  def show
    @scale = Scale.find(params[:id])
    render json: @scale
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ölçek bulunamadı." }, status: :not_found
  end

  def create
    user_id_param = scale_params[:user_id].to_i
    
    @user = User.find(user_id_param)

    unless @user.use_credits(SCALE_CREATION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Ölçek oluşturma maliyeti: #{SCALE_CREATION_COST} kredi.",
        current_balance: @user.credit_balance
      }, status: :payment_required 
    end

    @scale = @user.scales.new(scale_params)
    
    if @scale.save
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

    @scale.destroy! 
    
    head :no_content 
    
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek ölçek bulunamadı." }, status: :not_found
  end

  private
  
  def scale_params
    permitted_keys = [:title, :version, :is_public, :unique_scale_id, :user_id]
    
    if params[:scale].present?
      params.require(:scale).permit(*permitted_keys)
    else
      params.permit(*permitted_keys)
    end
  end
end