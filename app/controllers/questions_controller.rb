class QuestionsController < ApplicationController

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to root_url
    else
      render :new
    end
  end

  private
  def question_params
    params.require(:question).permit(:survey_id, :question, :question_type)
  end
end
