class Api::V1::ResponsesController < ApplicationController
  # Kredi maliyetini sınıf seviyesine taşıyoruz.
  # SDP Kuralı: Veri toplama maliyeti 1 kredidir (1-2 kredi/yanıt)
  DATA_COLLECTION_COST = 1 

  # POST 
  def create
    # Önemli: surveys rotası iç içe olduğu için önce Survey kaydını bulmalıyız.
    @survey = Survey.find(params[:survey_id])
    @user = @survey.scale.user # Varsayım: Krediyi ölçeğin sahibinden düşüreceğiz
    
    unless @user.use_credits(DATA_COLLECTION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Veri toplama maliyeti: #{DATA_COLLECTION_COST} kredi." 
      }, status: :payment_required
    end

    @response = @survey.responses.new(response_params)
    
    if @response.save
      # Kredi İşlemini kaydet
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
      }, status: :created
    else
      render json: @response.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end

  # Listeleme
  def index
    @survey = Survey.find(params[:survey_id])
    render json: @survey.responses
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end
  
  # GET 
  def show
    @response = Response.find(params[:id])
    render json: @response
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Yanıt kaydı bulunamadı." }, status: :not_found
  end

  # Güncelleme 
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

  # DELETE 
  def destroy
    @response = Response.find(params[:id])
    @response.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Yanıt kaydı bulunamadı." }, status: :not_found
  end

  private


  def response_params
    params.require(:response).permit(:participant_id, raw_data: {}) 
  end
end