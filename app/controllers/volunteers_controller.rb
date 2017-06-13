class VolunteersController < ApplicationController
  before_action :load_volunteer, only: [:show, :edit, :update, :destroy, :view_org, :add_locations, :remove_location, :add_vol_location]
  before_action :volunteer_organizations, only: [:show]

  def index
    @volunteers = Volunteer.all
    if request.xhr?
      @organization = Organization.where(name: params['org_name'])[0]
      @locations = @organization.locations
      respond_to do |format|
        format.html
        format.json { render json: @locations }
      end
    end
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(
      birthdate: volunteer_params[:birthdate].to_date,
      phone_number: volunteer_params[:phone_number],
      user_id: session[:user_id]
    )
    if @volunteer.save
      session[:volunteer_id] = @volunteer.id
      redirect_to volunteer_path(@volunteer)
    else
      flash.now[:alert] = @volunteer.errors.full_messages
      render :new
    end
  end

  def show
    volunteer_organizations
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

  def view_org
    @org = Organization.find(params[:org_id])
    @org_locations = @org.locations
    @volunteer = Volunteer.find(params[:id])
    @v_locations = @volunteer.locations.where(organization_id: @org.id)
    # byebug
    @org_surveys = []
    @org_locations.each do |loc|
      loc.surveys.each do |surv|
        @org_surveys << surv
      end
    end

    responses = @volunteer.responses
    @v_surveys = []
    responses.each do |r|
      @v_surveys << r.question.survey
    end
    @v_surveys = @v_surveys.uniq
  end

  def add_organizations

  end

  def remove_location
    @location = Location.find(params[:loc_id])
    @locations = @volunteer.locations
    @locations.delete(@location)
    redirect_to view_org_path(id: @volunteer.id, org_id: params[:org_id])
  end

  def add_vol_location
    @location = Location.find(params[:loc_id])
    @locations = @volunteer.locations
    @locations << @location
    redirect_to view_org_path(id: @volunteer.id, org_id: params[:org_id])
  end

  def add_locations
    volunteer_organizations
    @organization = Organization.new
    @organizations = Organization.all
    @uniq_organizations = (@organizations - @v_organizations).uniq
    # @organization = Organization.find(params[:organization][:name])
    # @locations = @organization.locations
    @new_location = Location.new
  end

  def associate_locations
    byebug
    volunteer = Volunteer.find(params[:id])
    location_ids = params[:location][:branch_name]
    locations = []
    i = 1
    while i < location_ids.count
      locations << Location.find(location_ids[i])
      i+=1
    end
    locations.each do |loc|
      volunteer.locations << loc
    end
    redirect_to view_org_path(id: params[:id], org_id: params[:location][:organization_id])
  end

  private

  def volunteer_organizations
    @v_locations = @volunteer.locations
    @v_organizations = []
    @v_locations.each do |location|
      @v_organizations << location.organization
    end
    @v_organizations = @v_organizations.uniq
  end

  def volunteer_params
    params.require(:volunteer).permit(:birthdate, :phone_number, :user_id)
  end

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

end
