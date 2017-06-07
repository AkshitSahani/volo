class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :account_type, :avatar])
  end

  def after_sign_up_path_for(user)
    new_resident_path
  end

  def after_inactive_sign_up_path_for(user)
    new_resident_path
  end

end
