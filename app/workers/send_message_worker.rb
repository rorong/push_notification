# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379' }
end
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379' }
end

# This Worker is used for send the notification in android and ios
class SendMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def fcm_connection
    @fcm_connection ||= FCM.new(ENV['fcm_key'])
  end

  def pusher
    Grocer.pusher(
      # path to certificates
      # Put your apn_development.pem and apn_production.pem certificates
      # from Apple in your RAILS_ROOT/config/certs directory.
      certificate: "#{Rails.root}/config/certs/apn_development.pem",
      retries: 3
    )
  end

  def ios_notification(device_token, message)
    # `device_token` and either `alert` or `badge` are required.
    notification = Grocer::Notification.new(
      device_token: device_token,
      alert: message,
      sound: 'default',
      category: 'a category', # optional;
      expiry: Time.now + 60 * 60, # optional;
      content_available: true, # optional;
      mutable_content: true # optional;
    )
    pusher.push(notification)
  end

  def perform(platform, device_token, message, custom_data = {})
    # Put your apn_development.pem and apn_production.pem certificates
    # from Apple in your RAILS_ROOT/config/certs directory.
    # unless Rails.env == :test
    return if Rails.env == :test

    return unless %w[iOS android].include?(platform)

    if platform == 'iOS'
      ios_notification(device_token, message)
    else
      data = { message: message }.merge(custom_data)
      fcm_connection.send([device_token], data: data)
    end
  end
end
