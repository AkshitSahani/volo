class LocationsController < ApplicationController
  before_action :load_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    if request.xhr? && params['branch_name']
      @location = Location.where(branch_name: params['branch_name'])[0]
      @surveys = @location.surveys
      respond_to do |format|
        format.html
        format.json { render json: @surveys }
      end
    elsif request.xhr? && params['match_type']
      @location = Location.where(branch_name: params['branch'])[0]
      @survey = Survey.find(params['survey_id'])
      if params['match_type'] == 'Volunteer -> Resident'
        # @participant = Volunteer.all
        # @participants = []
        # @participant.each do |par|
        #   @participants << User.find(par.user_id)
        # end
        # @participants #all of this is to test since most of the below queries give empty arrays.

        # actual code
        @participants = []
        @responses = []

        volunteers = @location.volunteers
        responses = @survey.responses.where.not(volunteer_id: nil)

        responses.each do |resp|
          @responses << resp if volunteers.include?(Volunteer.find(resp.volunteer_id))
        end

        @responses.each do |resp|
          @participants << resp.volunteer.user
        end

      elsif params['match_type'] == 'Resident -> Volunteer'
        # @participants = Resident.all.each do |res| User.find(res.user_id) end
        residents = Resident.where(location_id: @location.id)
        responses = @survey.responses.where.not(resident_id: nil)

        @participants = []
        @responses = []

        responses.each do |resp|
          @responses << resp if residents.include?(Resident.find(resp.resident_id))
        end

        @responses.each do |resp|
          @participants << resp.resident.user
        end

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
    @location = Location.find(params[:id])
  end
end
