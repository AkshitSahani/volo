class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :load_account_types, only: [:new, :create]

  # GET /resource/sign_up
  def new

    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.save
    if resource.account_type == "Volunteer"
      user = Volunteer.create(user_id: resource.id)
    elsif resource.account_type == "Resident"
      user = Resident.create(user_id: resource.id)
      #this needs Sahani's code to be added in the registration JS for auto generating org, locations
    else
      user = Organization.create(address: params['organization']['address'], user_id: resource.id)
    end
    session[:user_id] = resource.id
    session[:user_type] = resource.account_type
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(user)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(user)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def after_sign_up_path_for(user)
    if params[:user][:account_type] == "Organization"
      organization_url(user)
    elsif params[:user][:account_type] == "Resident"
      resident_url(user)
    elsif params[:user][:account_type] == "Volunteer"
      volunteer_url(user)
    end
  end

  def after_inactive_sign_up_path_for(user)
    if params[:user][:account_type] == "Organization"
      organization_url(user)
    elsif params[:user][:account_type] == "Resident"
      resident_url(user)
    elsif params[:user][:account_type] == "Volunteer"
      volunteer_url(user)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :account_type, :avatar, :phonenumber, :birthdate])
  end

 def load_account_types
   @account_types = ['Organization', 'Volunteer', 'Resident']
 end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up for inactive accounts.

end
