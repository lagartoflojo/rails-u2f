class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      flash[:notice] = "Logged in!"
      log_in(user)
      redirect_to user_url(current_user)
    else
      flash.now[:notice] = "Bad auth params"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
