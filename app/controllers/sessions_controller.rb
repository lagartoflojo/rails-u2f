class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      flash[:notice] = "Logged in!"
      log_in(user)
      redirect_to users_url
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
