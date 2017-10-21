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
    unless logged_in?
      flash[:notice] = 'Only logged in users can access this page.'
      redirect_to login_path
    end
  end
end
