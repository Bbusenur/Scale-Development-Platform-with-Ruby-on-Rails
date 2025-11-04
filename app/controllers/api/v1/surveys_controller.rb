class Api::V1::SurveysController < ApplicationController
  SURVEY_CREATION_COST = 8 
  
  def create
    @scale = current_user.scales.find(params[:scale_id])
    return render json: { error: "Scale not found or unauthorized" }, status: :not_found unless @scale
    
    @user = current_user 
    
    unless @user.use_credits(SURVEY_CREATION_COST) 
      return render json: { 
        error: "Yetersiz kredi bakiyesi. Anket oluşturma maliyeti: #{SURVEY_CREATION_COST} kredi.",
        current_balance: @user.credit_balance
      }, status: :payment_required 
    end

    survey_attrs = survey_params.to_h.merge(status: 'Draft')
    
    # Questions nested attributes işle
    if params[:questions].present?
      survey_attrs[:questions_attributes] = params[:questions].map.with_index do |q, index|
        question_attrs = {
          text: q[:text] || q['text'],
          question_type: q[:type] || q[:question_type] || q['type'] || 'text',
          order: index
        }
        
        # Options'ları JSON olarak text alanına ekle (geçici çözüm - sonra options kolonu eklenebilir)
        if q[:options].present? && (q[:type] == 'multiple_choice' || q[:type] == 'checkbox')
          question_attrs[:text] = "#{question_attrs[:text]}\n[OPTIONS:#{q[:options].join('|')}]"
        end
        
        question_attrs
      end
    end
    
    @survey = @scale.surveys.new(survey_attrs)
    
    if @survey.save
      CreditTransaction.create(
        user: @user,
        cost: SURVEY_CREATION_COST,
        activity_type: 'SurveyCreation',
        transaction_date: Time.current
      )
      
      # Survey'yi questions ile birlikte döndür
      render json: @survey.as_json(include: :questions), status: :created
    else
      render json: { message: @survey.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen ölçek bulunamadı." }, status: :not_found
  end
  
  def index
    # Sadece current_user'ın surveys'lerini göster
    if current_user
      # User'ın scales'lerinden surveys'leri topla
      user_scale_ids = current_user.scales.pluck(:id)
      @surveys = Survey.where(scale_id: user_scale_ids).includes(:questions)
      
      if params[:scale_id]
        @scale = current_user.scales.find(params[:scale_id])
        @surveys = @scale.surveys.includes(:questions) if @scale
      end
    else
      @surveys = []
    end
    
    render json: @surveys.as_json(include: :questions)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen ölçek bulunamadı." }, status: :not_found
  end

  def show
    @survey = Survey.find(params[:id])
    
    # Sadece current_user'ın survey'sini göster
    unless current_user && @survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    render json: @survey.as_json(include: :questions)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "İstenen anket bulunamadı." }, status: :not_found
  end
  
  def update
    @survey = Survey.find(params[:id])
    
    # Sadece survey'nin sahibi güncelleyebilir
    unless current_user && @survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    survey_attrs = survey_params.to_h
    
    # Questions nested attributes işle
    if params[:survey].present? && params[:survey][:questions].present?
      survey_attrs[:questions_attributes] = params[:survey][:questions].map.with_index do |q, index|
        question_attrs = {
          text: q[:text] || q['text'],
          question_type: q[:type] || q[:question_type] || q['type'] || 'text',
          order: index
        }
        
        # Options'ları JSON olarak text alanına ekle (geçici çözüm - sonra options kolonu eklenebilir)
        if q[:options].present? && (q[:type] == 'multiple_choice' || q[:type] == 'checkbox')
          question_attrs[:text] = "#{question_attrs[:text]}\n[OPTIONS:#{q[:options].join('|')}]"
        end
        
        # Eğer question id varsa, mevcut soruyu güncelle, yoksa yeni soru oluştur
        if q[:id].present? || q['id'].present?
          question_attrs[:id] = q[:id] || q['id']
        end
        
        question_attrs
      end
    elsif params[:questions].present?
      survey_attrs[:questions_attributes] = params[:questions].map.with_index do |q, index|
        question_attrs = {
          text: q[:text] || q['text'],
          question_type: q[:type] || q[:question_type] || q['type'] || 'text',
          order: index
        }
        
        # Options'ları JSON olarak text alanına ekle (geçici çözüm - sonra options kolonu eklenebilir)
        if q[:options].present? && (q[:type] == 'multiple_choice' || q[:type] == 'checkbox')
          question_attrs[:text] = "#{question_attrs[:text]}\n[OPTIONS:#{q[:options].join('|')}]"
        end
        
        # Eğer question id varsa, mevcut soruyu güncelle, yoksa yeni soru oluştur
        if q[:id].present? || q['id'].present?
          question_attrs[:id] = q[:id] || q['id']
        end
        
        question_attrs
      end
    end
    
    if @survey.update(survey_attrs)
      render json: @survey.as_json(include: :questions), status: :ok
    else
      render json: { message: @survey.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Güncellenecek anket bulunamadı." }, status: :not_found
  end

  def destroy
    @survey = Survey.find(params[:id])
    
    # Sadece survey'nin sahibi silebilir
    unless current_user && @survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    @survey.destroy! 
    
    head :no_content 

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek anket bulunamadı." }, status: :not_found
  end
  
  private

  def survey_params
    # Frontend'den distributionMode geliyorsa distribution_mode'a dönüştür
    if params[:survey].present?
      survey_data = params.require(:survey).permit(:title, :distribution_mode, :distributionMode)
      # distributionMode varsa distribution_mode'a dönüştür
      survey_data[:distribution_mode] = survey_data[:distributionMode] if survey_data[:distributionMode].present?
      survey_data.delete(:distributionMode)
      survey_data
    else
      params.permit(:title, :distribution_mode, :distributionMode).tap do |p|
        p[:distribution_mode] = p[:distributionMode] if p[:distributionMode].present?
        p.delete(:distributionMode)
      end
    end
  end
end