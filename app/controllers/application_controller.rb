class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    @_current_user ||= User.find_by(id: session[:user_id])
  end

  def log_in(user)
    reset_session
    session[:user_id] = user.id
  end

  def log_out
    reset_session
  end

  def logged_in?
    current_user.present?
  end

  def require_user
    if logged_in?
      unless device_authenticated?
        redirect_to new_device_authentication_path, notice: 'To log in, you need you security key.'
      end
    else
      redirect_to login_path, notice: 'Only logged in users can access this page.'
    end
  end

  def u2f
    # use base_url as app_id, e.g. 'http://localhost:3000'
    @u2f ||= U2F::U2F.new(request.base_url)
  end

  def device_authenticated?
    current_user.devices.any? ? session[:device_authenticated] : true
  end

  def authenticate_with_device
    session[:device_authenticated] = true
  end

  def require_admin
    unless current_user.admin?
      redirect_to user_path(current_user), notice: 'Only admins can access this page.'
    end
  end
end
