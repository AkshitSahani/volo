class LocationsController < ApplicationController
  before_action :load_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to location_path(@location)
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
    if @location.update_attributes(location_params)
      redirect_to location_path(@location)
    else
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path
  end

  private

  def location_params
    params.require(:location).permit(:branch_name, :address, :phone_number, :volunteer_coordinator_name, :volunteer_coordinator_phone, :organization_id)
  end

  def load_location
    @location = Location.find(params[:location_id])
  end
end
