class SurveysController < ApplicationController
  before_action :load_survey, only: [:show, :edit, :update, :destroy, :show, :preview]
  before_action :load_question_types, only: [:new, :create]
  before_action :question_set, only: [:show, :preview]

  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to preview_path(@survey) #Change this once you decide user flows.
    else
      render :new
    end
  end

  def show
    num_questions = @survey.questions.count
    @responses = []
    num_questions.times do
      @responses << Response.new
    end
    @q_counter = 0
  end

  def create_responses
    params["responses"].each do |response|
      Response.create(response_params(response))
    end
    redirect_to root_path #update this based on who is responding to the survey
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

  def preview
  end

private

  def question_set
    @question_set = []
    @survey.questions.each do |q|
      question = q
      answers = []
      q.answer_sets.each do |a|
        answers << a
      end
      @question_set << [question,answers]
    end
    @question_set
  end

  def survey_params
    params.require(:survey).permit(
    :name, :location_id,
    questions_attributes: [:survey_id, :question, :question_type, :ranking, answer_sets_attributes: [:question_id, :answer, :_destroy]]
    )
  end

  def response_params(r_params)
    r_params.permit(:question_id, :response, :volunteer_id, :resident_id)
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end

  def load_question_types
    @question_types = ['Multiple Choice', 'Drop-Down', 'Open Response']
  end

end
