class ResidentsController < ApplicationController

  before_action :load_resident, only: [:show, :edit, :update, :destroy]
  before_action :configure_form, only: [:new, :create]

  def index
    @residents = Resident.all
  end

  def new
    @resident = Resident.new
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
    #code
  end

  def edit
    #code
  end

  def update
    if @resident.update_attributes(resident_params)
      redirect_to resident_path(@resident)
    else
      render :edit
    end
  end

  def destroy
    @resident.destroy
    redirect_to residents_path
  end

  private

  def resident_params
    params.require(:resident).permit(:age, :location_id, :user_id)
  end

  def load_resident
    @resident = Resident.find(params[:id])
  end

  def configure_form
    @resident = Resident.new
    @locations = [['SV',1],['RS',2]]
  end
      
end
