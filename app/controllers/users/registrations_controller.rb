class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :load_user_types, only: [:new, :create]


  def register_type
  end

  def new_volunteer
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def new_resident
    @organizations = User.where(user_type: "Organization")
    @locations = []
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def new_organization
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def get_locations
    if request.xhr? && params['organization']
      @user = User.where(first_name: params['organization'])[0]
      @organization = Organization.where(user_id: @user.id)[0]
      @locations = @organization.locations
      respond_to do |format|
        format.json { render json: @locations }
      end
    end
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    byebug
    resource.save
    if resource.user_type == "Volunteer"
      user = Volunteer.create(user_id: resource.id)
    elsif resource.user_type == "Resident"
      user = Resident.create(user_id: resource.id, location_id: res_params(params)[:location_id].to_i)
    else
      user = Organization.create(name: sign_up_params[:first_name], address: org_params(params)[:address], user_id: resource.id)
    end
    session[:user_id] = resource.id
    session[:user_type] = resource.user_type
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
    if params[:user][:user_type] == "Organization"
      organization_url(user)
    elsif params[:user][:user_type] == "Resident"
      resident_url(user)
    elsif params[:user][:user_type] == "Volunteer"
      volunteer_url(user)
    end
  end

  def after_inactive_sign_up_path_for(user)
    if params[:user][:user_type] == "Organization"
      organization_url(user)
    elsif params[:user][:user_type] == "Resident"
      resident_url(user)
    elsif params[:user][:user_type] == "Volunteer"
      volunteer_url(user)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_type, :avatar, :phonenumber, :birthdate])
  end

  def org_params(params)
    params.permit(:address)
  end

  def res_params(params)
    params.permit(:location_id)
  end


 def load_user_types
   @user_types = ['Organization', 'Volunteer', 'Resident']
 end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up for inactive accounts.

end
