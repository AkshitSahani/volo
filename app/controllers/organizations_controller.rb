class OrganizationsController < ApplicationController
  before_action :load_organization, only: [:show, :edit, :update, :destroy, :view_surveys, :assign_locations, :nest_locations, :view_locations]

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(
      location: organization_params[:location],
      phone_number: organization_params[:phone_number],
      user_id: session[:user_id],
      name: "#{User.find(session[:user_id]).first_name} #{User.find(session[:user_id]).last_name}"
    )

    if @organization.save
      @organization.name =
      session[:organization_id] = @organization.id
      redirect_to organization_path(@organization)
    else
      flash.now[:alert] = @organization.errors.full_messages
      render :new
    end
  end

  def show
    #code
    @current_organization_id = session[:organization_id]
    @surveys = Survey.where(organization_id: @current_organization_id)

  end

  def edit
    #code
  end

  def update
    if @organization.update_attributes(organization_params)
      redirect_to organization_path(@organization)
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path
  end

  def view_surveys
    @surveys = @organization.surveys
  end

  def assign_locations
    @organization = Organization.find(@organization)
    @location = Location.new
    @survey = Survey.find(params[:survey_id])
    @selected = []
    @survey.locations.each do |loc|
      @selected << loc.id
    end
  end

  def assign
    @survey = Survey.find(params[:survey_id])
    @survey.locations.delete_all
    params[:branch_name].each do |loc|
      @survey.locations << Location.find(loc) if !loc.empty?
    end
    redirect_to organization_path(params[:id])
  end

  def nest_locations

  end

  def view_locations
    #code
  end

  private

  def organization_params
    params.require(:organization).permit(:location, :phone_number, :user_id,
    locations_attributes:[:id, :branch_name, :address, :phone_number, :volunteer_coordinator_name,
    :volunteer_coordinator_phone, :organization_id, :_destroy])
  end

  def load_organization
    @organization = Organization.find(params[:id])
  end
end
