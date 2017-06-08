class LocationsController < ApplicationController
  before_action :load_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all

    if request.xhr? && params['branch_name']
      @location = Location.where(branch_name: params['branch_name'])[0]
      # @surveys = @location.surveys #actual code
      @surveys = Survey.all #also to test. Should actually be like 9.
      respond_to do |format|
        format.html
        format.json { render json: @surveys }
      end
    elsif request.xhr? && params['match_type']
      @location = Location.where(branch_name: params['branch'])[0]
      @survey = Survey.find(params['survey_id'])
      if params['match_type'] == 'Resident -> Volunteer'
        @participant = Volunteer.all
        @participants = []
        @participant.each do |par|
          @participants << User.find(par.user_id)
        end
        @participants #all of this is to test since most of the below queries give empty arrays.

        #actual code
        # @participants = []
        # a = @location.volunteers
        # b = @survey.responses.where.not(volunteer_id: nil)
        #
        # b.each do |vol|
        #   @participants << vol if a.include?(vol)
        # end
        #
        # @participants.map { |par| User.find(par.user_id) } #chose to use users so that we can display names

      elsif params['match_type'] == 'Volunteer -> Resident'
        # @participants = Resident.all.each do |res| User.find(res.user_id) end
        a = Resident.where(location_id: @location.id)
        b = @survey.responses.where.not(resident_id: nil)

        @participants = []

        b.each do |res|
          @participants << res if a.include?(res)
        end

        @participants.map { |par| User.find(par.user_id) }
      end
      respond_to do |format|
        format.html
        format.json { render json: @participants }
      end
    end
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
