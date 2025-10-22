class Api::V1::AnalysisController < ApplicationController
  # POST /api/v1/analysis
  def create
    # Analiz Maliyeti: 5-15 Kredi [cite: 117-118]
    ANALYSIS_COST = 10 

    @user = User.first # Geçici kullanıcı
    
    unless @user.use_credits(ANALYSIS_COST)
      return render json: { error: "Analiz için yeterli kredi yok. Maliyet: #{ANALYSIS_COST} kredi." }, status: :payment_required
    end
    
    # Model kaydı oluşturulur
    @analysis = Analysis.new(analysis_params.merge(status: 'Running'))

    if @analysis.save
      # Gerçek uygulamada: Burada Ruby, R tabanlı istatistik motorunu çağırır 
      # @analysis.run_statistical_analysis 
      
      CreditTransaction.create(
        user: @user,
        cost: ANALYSIS_COST,
        activity_type: 'Analysis', # [cite: 117-118]
        transaction_date: Time.current
      )
      render json: @analysis, status: :accepted, location: api_v1_analysis_url(@analysis)
    else
      render json: @analysis.errors, status: :unprocessable_entity
    end
  end

  # GET /api/v1/analysis/:id
  def show
    @analysis = Analysis.find(params[:id])
    render json: @analysis
  end

  private

  def analysis_params
    # Örnek parametreler: Hangi anketin verisi kullanılacak ve hangi analiz türü (Faktör, Korelasyon)
    params.require(:analysis).permit(:survey_id, :analysis_type)
  end
end
