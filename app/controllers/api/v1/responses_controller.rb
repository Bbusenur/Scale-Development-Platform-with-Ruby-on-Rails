class Api::V1::ResponsesController < ApplicationController
  DATA_COLLECTION_COST = 1 

  def create
    @survey = Survey.find(params[:survey_id])
    @user = @survey.scale.user 
    
    unless @user.use_credits(DATA_COLLECTION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Veri toplama maliyeti: #{DATA_COLLECTION_COST} kredi." 
      }, status: :payment_required
    end

    @response = @survey.responses.new(response_params)
    
    if @response.save
      CreditTransaction.create(
        user: @user,
        cost: DATA_COLLECTION_COST,
        activity_type: 'DataCollection',
        transaction_date: Time.current
      )
      
      @response.validate_data 
      
      render json: { 
        message: "Yanıt başarıyla kaydedildi.",
        response: @response 
      }, status: :accepted
    else
      render json: @response.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end

  def index
    @survey = Survey.find(params[:survey_id])
    render json: @survey.responses
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end
  
  def show
    @response = Response.find(params[:id])
    render json: @response
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Yanıt kaydı bulunamadı." }, status: :not_found
  end

  def update
    @response = Response.find(params[:id])
    if @response.update(response_params)
      render json: @response, status: :ok
    else
      render json: @response.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Yanıt kaydı bulunamadı." }, status: :not_found
  end

  def destroy
    @response = Response.find(params[:id])
    @response.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Yanıt kaydı bulunamadı." }, status: :not_found
  end

  def create_flat
    # Frontend'den flat route ile gelen survey response
    survey_id = params[:surveyId] || params[:survey_id]
    @survey = Survey.find(survey_id)
    
    # Token'dan user'ı bul
    @user = current_user
    return render json: { error: "Unauthorized" }, status: :unauthorized unless @user
    
    # Survey'nin user'ın survey'si olduğunu kontrol et
    unless @survey.scale.user_id == @user.id
      return render json: { error: "Unauthorized - Survey does not belong to user" }, status: :unauthorized
    end
    
    unless @user.use_credits(DATA_COLLECTION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Veri toplama maliyeti: #{DATA_COLLECTION_COST} kredi." 
      }, status: :payment_required
    end

    # Frontend'den gelen responses formatını raw_data'ya dönüştür
    raw_data = params[:responses] || {}
    
    @response = @survey.responses.new(
      participant_id: params[:participant_id] || SecureRandom.uuid,
      raw_data: raw_data
    )
    
    if @response.save
      CreditTransaction.create(
        user: @user,
        cost: DATA_COLLECTION_COST,
        activity_type: 'DataCollection',
        transaction_date: Time.current
      )
      
      @response.validate_data 
      
      head :ok
    else
      render json: { message: @response.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end

  private

  def response_params
    if params[:response].present?
      params.require(:response).permit(:participant_id, raw_data: {})
    else
      params.permit(:participant_id, raw_data: {})
    end 
  end
end