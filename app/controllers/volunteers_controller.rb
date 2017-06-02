class VolunteersController < ApplicationController
  before_action :load_volunteer, only: [:show, :edit, :update, :destroy]

  def index
    @volunteers = Volunteer.all
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      redirect_to volunteer_path(@volunteer)
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

  private

  def volunteer_params
    params.require(:volunteer).permit(:age, :phone_number, :user_id)
  end

  def load_volunteer
    @volunteer = Volunteer.find(params[:id])
  end
end
