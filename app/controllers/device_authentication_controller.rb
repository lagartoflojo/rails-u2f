class DeviceAuthenticationController < ApplicationController
  before_action :require_user
  # before_action :require_key

  def new
    key_handles = current_user.devices.map(&:key_handle)

    @app_id = u2f.app_id
    @sign_requests = u2f.authentication_requests(key_handles)
    @challenge = u2f.challenge
    session[:u2f_challenge] = @challenge
  end

  def create
    response = U2F::SignResponse.load_from_json(params[:response])
    challenge = session[:u2f_challenge]
    session.delete(:u2f_challenge)

    device = current_user.devices.find_by(key_handle: response.key_handle)

    begin
      u2f.authenticate!(challenge, response,
                           Base64.decode64(device.public_key),
                           device.counter)
    rescue U2F::Error => e
      redirect_to new_device_authentication_path, notice: "Unable to authenticate: #{e.class.name}. Try again."
    end

    device.update(counter: response.counter)
    redirect_to devices_path, notice: "Authenticated!"
  end
end
