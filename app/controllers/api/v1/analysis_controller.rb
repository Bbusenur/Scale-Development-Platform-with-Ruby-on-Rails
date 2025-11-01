class Api::V1::AnalysisController < ApplicationController
  ANALYSIS_COST = 10

  def index
    @analysis_results = Analysis.all 
    render json: @analysis_results, status: :ok
  end

  def create
    provided_user_id = params.dig(:analysis, :user_id) || params[:user_id]
    
    # Kullanıcıyı bulma mantığı
    if provided_user_id.present?
      @user = User.find(provided_user_id)
    else
      # Eğer kullanıcı belirtilmemişse, bir politika uygulayabiliriz (örneğin: ilk kullanıcıyı kullan veya hata ver).
      # Mevcut koda sadık kalarak User.first kullanılıyor.
      @user = User.first 
      raise ActiveRecord::RecordNotFound, "User not specified and no default user found." unless @user
    end
    
    unless @user.use_credits(ANALYSIS_COST)
      return render json: { error: "Analiz için yeterli kredi yok. Maliyet: #{ANALYSIS_COST} kredi." }, status: :payment_required
    end
    
    @analysis = Analysis.new(analysis_params.merge(status: 'Running'))

    if @analysis.save
      CreditTransaction.create(
        user: @user,
        cost: ANALYSIS_COST,
        activity_type: 'Analysis',
        transaction_date: Time.current
      )
      render json: @analysis, status: :accepted, location: api_v1_analysis_url(@analysis)
    else
      render json: @analysis.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    # Kullanıcı veya varsayılan kullanıcı bulunamadığında yakalanır
    render json: { error: "Analiz başlatmak için geçerli bir kullanıcı bulunamadı." }, status: :not_found
  end

  def show
    @analysis = Analysis.find(params[:id])
    render json: @analysis
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Analiz sonucu bulunamadı." }, status: :not_found
  end

  private

  def analysis_params
    permitted_keys = [:survey_id, :analysis_type]
    if params[:analysis].present?
      params.require(:analysis).permit(*permitted_keys)
    else
      params.permit(*permitted_keys)
    end
  end
end