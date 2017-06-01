class ResidentsController < ApplicationController
  before_action :configure_form, only: [:new, :create]

  def new
  end

  def create
    @resident = Resident.new(
      age: resident_params[:age],
      location_id: resident_params[:location_id],
      user_id: session[:user_id]
      )
    if @resident.save
      redirect_to resident_path(@resident)
    else
      flash.now[:alert] = @resident.errors.full_messages
      render :new
    end
  end

  def show
  end

private

  def resident_params
    params.require(:resident).permit(:age, :location_id)
  end

  def configure_form
    @resident = Resident.new
    @locations = [['SV',1],['RS',2]]
  end

end
