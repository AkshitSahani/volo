class OrganizationsController < ApplicationController
  before_action :load_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to organization_path(@organization)
    else
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

  private

  def organization_params
    params.require(:organization).permit(:location, :phone_number, :user_id)
  end

  def load_organization
    @organization = Organization.find(params[:id])
  end
end
