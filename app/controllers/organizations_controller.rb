class OrganizationsController < ApplicationController
  before_action :load_organization, only: [:show, :edit, :update, :destroy, :view_surveys, :assign_locations]

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
      user_id: session[:user_id]
    )

    if @organization.save
      redirect_to organization_path(@organization)
    else
      flash.now[:alert] = @organization.errors.full_messages
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
    @location = Location.new
    @survey = params[:survey_id]
  end

  def assign
    @survey = Survey.find(params[:survey_id])
    @survey.location = Location.find(params[:location][:branch_name])
    redirect_to organization_path(params[:id])
  end

  private

  def organization_params
    params.require(:organization).permit(:location, :phone_number, :user_id)
  end

  def load_organization
    @organization = Organization.find(params[:id])
  end
end
