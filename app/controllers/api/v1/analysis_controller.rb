class Api::V1::AnalysisController < ApplicationController
  ANALYSIS_COST = 10

  def index
    # Sadece current_user'ın analyses'lerini göster
    if current_user
      # User'ın scales'lerinden surveys'leri, sonra analyses'leri topla
      user_scale_ids = current_user.scales.pluck(:id)
      user_survey_ids = Survey.where(scale_id: user_scale_ids).pluck(:id)
      @analysis_results = Analysis.where(survey_id: user_survey_ids)
    else
      @analysis_results = []
    end
    
    render json: @analysis_results, status: :ok
  end

  def create
    # Token'dan user'ı al
    @user = current_user
    return render json: { error: "Unauthorized" }, status: :unauthorized unless @user
    
    # Survey ID'den survey'yi bul ve user'ın survey'si olduğunu kontrol et
    survey_id = params[:survey_id] || params.dig(:analysis, :survey_id)
    if survey_id.present?
      survey = Survey.find(survey_id)
      unless survey.scale.user_id == @user.id
        return render json: { error: "Unauthorized - Survey does not belong to user" }, status: :unauthorized
      end
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
    
    # Sadece current_user'ın analysis'sini göster
    unless current_user && @analysis.survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    render json: @analysis
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Analiz sonucu bulunamadı." }, status: :not_found
  end

  def destroy
    @analysis = Analysis.find(params[:id])
    
    # Sadece analysis'nin sahibi silebilir
    unless current_user && @analysis.survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    @analysis.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek analiz bulunamadı." }, status: :not_found
  end

  private

  def analysis_params
    permitted_keys = [:survey_id, :analysis_type, :analysisType, :title, :description]
    if params[:analysis].present?
      params.require(:analysis).permit(*permitted_keys)
    else
      params.permit(*permitted_keys)
    end.tap do |p|
      # Frontend'den analysisType geliyorsa analysis_type'a dönüştür
      p[:analysis_type] = p[:analysisType] if p[:analysisType].present?
    end
  end
end