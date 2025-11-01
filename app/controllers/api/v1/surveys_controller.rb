class Api::V1::SurveysController < ApplicationController
  SURVEY_CREATION_COST = 8 
  
  def create
    @scale = Scale.find(params[:scale_id])
    
    @user = @scale.user 
    
    unless @user.use_credits(SURVEY_CREATION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Anket oluşturma maliyeti: #{SURVEY_CREATION_COST} kredi.",
        current_balance: @user.credit_balance
      }, status: :payment_required 
    end

    @survey = @scale.surveys.new(survey_params.merge(status: 'Draft'))
    
    if @survey.save
      CreditTransaction.create(
        user: @user,
        cost: SURVEY_CREATION_COST,
        activity_type: 'SurveyCreation',
        transaction_date: Time.current
      )
      
      render json: @survey, status: :created
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen ölçek bulunamadı." }, status: :not_found
  end
  
  def index
    if params[:scale_id]
      @scale = Scale.find(params[:scale_id])
      @surveys = @scale.surveys
    else
      @surveys = Survey.all
    end
    
    render json: @surveys
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen ölçek bulunamadı." }, status: :not_found
  end

  def show
    @survey = Survey.find(params[:id])
    render json: @survey
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen anket bulunamadı." }, status: :not_found
  end
  
  def update
    @survey = Survey.find(params[:id])
    
    if @survey.update(survey_params)
      render json: @survey, status: :ok
    else
      render json: @survey.errors, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Güncellenecek anket bulunamadı." }, status: :not_found
  end

  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy! 
    
    head :no_content 

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek anket bulunamadı." }, status: :not_found
  end
  
  private

  def survey_params
    params.require(:survey).permit(:title, :distribution_mode)
  end
end