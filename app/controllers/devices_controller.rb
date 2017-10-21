class DevicesController < ApplicationController
  before_action :require_user

  def new
    @registration_requests = u2f.registration_requests
    session[:challenges] = @registration_requests.map(&:challenge)

    key_handles = current_user.devices.map(&:key_handle)
    @sign_requests = u2f.authentication_requests(key_handles)

    @app_id = u2f.app_id
  end

  def index
    @devices = current_user.devices
  end

  def create
    response = U2F::RegisterResponse.load_from_json(params[:response])
    challenges = session[:challenges]
    session.delete(:challenges)

    begin
      reg = u2f.register!(challenges, response)

      current_user.devices.create!(certificate: reg.certificate,
                                       key_handle:  reg.key_handle,
                                       public_key:  reg.public_key,
                                       counter:      reg.counter)
    rescue U2F::Error => e
      redirect_to new_device_path, notice: "Unable to register: #{e.class.name}. Try again."
    end

    redirect_to devices_path, notice: 'Device registered.'
  end

  def destroy
    device = current_user.devices.find(params[:id])
    device.destroy

    redirect_to devices_path, notice: "Device removed."
  end
end
