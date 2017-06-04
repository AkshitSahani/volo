class VolunteersController < ApplicationController
  before_action :load_volunteer, only: [:show, :edit, :update, :destroy, :view_organizations, :add_organizations]

  def index
    @volunteers = Volunteer.all
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(
      age: volunteer_params[:age],
      phone_number: volunteer_params[:phone_number],
      user_id: session[:user_id]
    )
    if @volunteer.save
      redirect_to volunteer_path(@volunteer)
    else
      flash.now[:alert] = @volunteer.errors.full_messages
      render :new
    end
  end

  def show
    #code
  end

  def edit
    #code
  end

  def update
    if @volunteer.update_attributes(volunteer_params)
      redirect_to volunteer_path(@volunteer)
    else
      render :edit
    end
  end

  def destroy
    @volunteer.destroy
    redirect_to volunteers_path
  end

  def view_organizations
    @v_locations = @volunteer.locations

    @v_organizations = []
    @v_locations.each do |location|
      @v_organizations << location.organization
    end

    responses = @volunteer.responses
    @surveys = []
    responses.each do |r|
      @surveys << r.question.survey
    end
    @surveys = @surveys.uniq
  end

  def add_organizations
    @v_locations = @volunteer.locations
    @v_organizations = []
    @v_locations.each do |location|
      @v_organizations << location.organization
    end

    @organizations = Organization.all
    @organizations = @organizations - @v_organizations

    @organization = Organization.new
  end

  def add_locations
    @organization = Organization.find(params[:organization][:name])
    @locations = @organization.locations
    @new_location = Location.new
  end

  def associate_locations
    volunteer = Volunteer.find(params[:id])
    location = Location.find(params[:location][:branch_name])
    volunteer.locations << location
    redirect_to view_organizations_path
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:age, :phone_number, :user_id)
  end

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end
end
