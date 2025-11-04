class Api::V1::QuestionsController < ApplicationController
  def create
    @survey = Survey.find(params[:survey_id])
    
    # Sadece survey'nin sahibi soru ekleyebilir
    unless current_user && @survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    @question = @survey.questions.new(question_params)
    
    if @question.save
      render json: @question, status: :created
    else
      render json: { message: @question.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Anket bulunamadı." }, status: :not_found
  end
  
  def destroy
    @question = Question.find(params[:id])
    
    # Sadece question'ın survey'sinin sahibi silebilir
    unless current_user && @question.survey.scale.user_id == current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
    
    @question.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Soru bulunamadı." }, status: :not_found
  end
  
  private
  
  def question_params
    params.require(:question).permit(:text, :question_type, :order)
  end
end

