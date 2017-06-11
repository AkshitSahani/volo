class SurveysController < ApplicationController
  before_action :load_survey, only: [:show, :edit, :update, :destroy, :show, :preview, :delete_responses, :edit_responses]
  before_action :load_question_types, only: [:new, :create, :edit]
  before_action :question_set, only: [:show, :preview]
  before_action :load_respondent, only: [:show, :edit_responses, :delete_responses]
  before_action :load_organization, only: [:show, :edit_responses, :delete_responses]
  before_action :load_questions, only: [:edit_responses, :delete_responses]

  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
    @organizations = Organization.all
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.organization_id = session[:organization_id] #we should be testing by logging in as an organization
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

      if response[:response].is_a? Array
        Response.create(
          question_id: response_params(response)[:question_id],
          volunteer_id: response_params(response)[:volunteer_id],
          resident_id: response_params(response)[:resident_id],
          response: response_params(response)[:response].reject(&:empty?).join(', ')
        )
      else
        Response.create(response_params(response))
      end
    end
    if session[:volunteer_id]
      redirect_to view_org_path(id: session[:volunteer_id], org_id: params[:organization_id])
    elsif session[:resident_id]
      redirect_to resident_path(session[:resident_id])
    else
      redirect_to root_url #not sure where this should go atm
    end
  end

  def edit
      @organizations = Organization.all
  end

  def update
    if @survey.update_attributes(survey_params)
      redirect_to preview_path(@survey) #Change this once you decide user flows.
      # organization_url(Organization.find(session[:organization_id]))
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
  end

  def preview
  end

  def edit_responses
    @responses = []
    @question_set = []
    @questions.each do |q|
      answers = []
      q.answer_sets.each do |a|
        answers << a
      end
      if session[:volunteer_id]
        response = q.responses.where(volunteer_id: @respondent).take
      elsif session[:resident_id]
        response = q.responses.where(resident_id: @respondent).take
      end
      response_ids = []
      response.response.split(', ').each do |r|
        response_ids << AnswerSet.where(question_id: q.id, answer: r).take.answer if AnswerSet.where(question_id: q.id, answer: r).take
      end
      @question_set << [q, answers, response_ids]
      @responses << response
    end
    @q_counter = 0
  end

  def update_responses
    params["responses"].each do |id, edits|
      response = Response.find(id)
      if edits[:response].is_a? Array
        response.update(
          response: response_params(edits)[:response].reject(&:empty?).join(', ')
        )
      else
        response.update(response_params(edits))
      end
    end

    if session[:volunteer_id]
      redirect_to view_org_path(id: session[:volunteer_id], org_id: params[:organization_id]) #update this based on who is responding to the survey
    elsif session[:resident_id]
      redirect_to resident_path(session[:resident_id])
    end
  end

  def delete_responses
    @responses = []
    @questions.each do |q|
      if session[:volunteer_id]
        response = q.responses.where(volunteer_id: @respondent).take
      elsif session[:resident_id]
        response = q.responses.where(resident_id: @respondent).take
      end
      @responses << response
    end
    @responses.each do |response|
      response.delete
    end

    if session[:volunteer_id]
      redirect_to view_org_path(id: session[:volunteer_id], org_id: @organization.id) #update this based on who is responding to the survey
    elsif session[:resident_id]
      redirect_to resident_path(session[:resident_id])
    end
  end

private

  def question_set
    @question_set = []
    @survey.questions.each do |q|
      answers = []
      q.answer_sets.each do |a|
        answers << a
      end
      @question_set << [q, answers]
    end
    @question_set
  end

  def survey_params
    params.require(:survey).permit(
    :name, :organization_id,
    questions_attributes: [:id, :survey_id, :question, :question_type, :ranking, :_destroy, answer_sets_attributes: [:id, :question_id, :answer, :_destroy]]
    )
  end

  def load_respondent
    if session[:volunteer_id]
      @respondent = session[:volunteer_id]
    elsif session[:resident_id]
      @respondent = session[:resident_id]
    end
  end

  def response_params(r_params)
    if r_params[:response].is_a? Array
      r_params.permit(:response_id, :question_id, {:response => []}, :volunteer_id, :resident_id, :organization_id)
    else
      r_params.permit(:response_id, :question_id, :response, :volunteer_id, :resident_id, :organization_id)
    end
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end

  def load_question_types
    @question_types = ['Multiple Choice', 'Drop-Down', 'Open Response', 'Display Text']
  end

  def load_organization
    @organization = @survey.organization
  end

  def load_questions
    @questions = @survey.questions
  end

end
