class SurveysController < ApplicationController
  before_action :load_survey, only: [:show, :edit, :update, :destroy]
  before_action :load_question_types, only: [:new, :create]
  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to preview_rank_path(@survey) #Change this once you decide user flows.
    else
      render :new
    end
  end

  def show
    @response = Response.new
  end

  def edit
  end

  def update
    if @survey.update_attributes(survey_params)
      redirect_to root_url #Change this once you decide user flows.
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
  end

  def preview_rank
    #Generate array containing all survey information
    @survey = Survey.find(params[:id])
    @question_set = []
    @survey.questions.each do |q|
      question = [q.id, q.question_type, q.question, q.ranking]
      answers = []
      q.answer_sets.each do |a|
        answers << [a.answer,a.id]
      end
      @question_set << [question,answers]
    end
  end

  def rank_survey
    #Rank survey questions

  end

private
  def rank_params
    params.require(:question).permit(
      :question_id,
      :ranking
    )
  end

  def survey_params
    params.require(:survey).permit(
    :name, :location_id,
    questions_attributes: [:survey_id, :question, :question_type, :ranking, answer_sets_attributes: [:question_id, :answer, :_destroy]]
    )
  end

  def response_params
    params.require(:response).permit(:response, :question_id, :resident_id, :volunteer_id)
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end

  def load_question_types
    @question_types = ['Multiple Choice', 'Drop-Down', 'Open Response']
  end

end
