class SurveysController < ApplicationController
  before_action :load_survey, only: [:show, :edit, :update, :destroy]

  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to root_url #Change this once you decide user flows.
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

  private
  def survey_params
    params.require(:survey).permit(:name, :location_id, questions_attributes: [:survey_id, :question, :question_type, :_destroy])
  end

  def response_params
    params.require(:response).permit(:response, :question_id, :resident_id, :volunteer_id)
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end
end
