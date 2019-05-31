class PushNotificationsController < ApplicationController
  def new
    @push_notification = PushNotification.new
  end

  def send_message
    @push_notification = PushNotification.new(push_notification_params)
    #device_token stored with mobile app
    #platform either android or iOS this is required due to multiple devices.
    device_token = 'c968jE-fr8U:APA91bHwJ1oioiXq0WNRCLiRvjIzhVVM4TKLljBBc1kJs7rGenR0kPOw3XCKlZ4kUOqwASjomZRYSWjlr2v25rgB7yTPYBImnsAlCJ2L6A0sv-mqn9zQ0CO5aLCge7mvY2gw9Qe1kIZg'
    SendMessageWorker.perform_async('android', device_token, @push_notification.message)
    flash[:notice] = "Your message was successfully scheduled and is currently being delivered to its recipients."
    redirect_to root_path
  end

  private

  def push_notification_params
    params.require(:push_notification).permit(:message)
  end
end
