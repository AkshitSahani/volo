class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    session[:user_id] = resource.id
    session[:user_type] = resource.user_type
    if session[:user_type] == "Volunteer"
      session[:volunteer_id] == Volunteer.where(user_id: session[:user_id])[0].id
    elsif session[:user_type] == "Resident"
      session[:resident_id] == Resident.where(user_id: session[:user_id])[0].id
    elsif session[:user_type] == "Organization"
      session[:organization_id] == Organization.where(user_id: session[:user_id][0].id
    end
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private
  def after_sign_in_path_for(resource)
    byebug
    type = resource.user_type
    if type == "Volunteer"
      volunteer = Volunteer.find(user_id: resource.id)
      volunteer_path(volunteer)
    elsif type == "Resident"
      resident = Resident.find(user_id: resource.id)
      resident_path(resident)
    elsif type == "Organization"
      organization = Organization.find(user_id: resource.id)
      organization_path(organization)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
