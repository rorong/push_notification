# frozen_string_literal: true

# This is for send push notification in devices.
class PushNotificationsController < ApplicationController
  def new
    @push_notification = PushNotification.new
  end

  def send_message
    @push_notification = PushNotification.new(push_notification_params)
    # device_token stored with mobile app
    # platform either android or iOS this is required due to multiple devices.
    SendMessageWorker.perform_async(platform, device_token, @push_notification
      .message)
    flash[:notice] = 'Your message was successfully scheduled and is currently
                      being delivered to its recipients.'
    redirect_to root_path
  end

  private

  def push_notification_params
    params.require(:push_notification).permit(:message)
  end
end
