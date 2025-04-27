class ApplicationController < ActionController::Base
  layout :set_layout

  # Check browser compatibility first
  allow_browser versions: :modern

  # Authenticate user after checking browser
  before_action :authenticate_user!

  # Devise strong parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_layout
    if controller_path.start_with?('admin/')
      "admin"   # => app/views/layouts/admin.html.erb
    else
      "public"  # => app/views/layouts/public.html.erb
    end
  end
end
