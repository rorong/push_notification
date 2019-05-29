Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379' }
end
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379' }
end

class SendMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def fcm_connection
    @fcm_connection ||= FCM.new(ENV['fcm_key'])
  end

  def perform(platform, push_notification_token, message, verb = nil, badge = 0, custom_data = {})
    #Put your apn_development.pem and apn_production.pem certificates from Apple in your RAILS_ROOT/config/certs directory.
    unless Rails.env == :test
      return unless ['iOS','android'].include?(platform)
      if platform == 'iOS'
        pusher = Grocer.pusher(
        certificate: '#{Rails.root}/config/certs/apn_development.pem', #path to certificates
        retries:     3
        )
        # `device_token` and either `alert` or `badge` are required.
        notification = Grocer::Notification.new(
        device_token:      push_notification_token,
        alert:             message,
        sound:             "default",
        category:          "a category", # optional; used for custom notification actions
        expiry:            Time.now + 60*60, # optional; 0 is default, meaning the message is not stored
        identifier:        1234, # optional; must be an integer
        content_available: true, # optional; any truthy value will set 'content-available' to 1
        mutable_content:   true, # optional; any truthy value will set 'mutable-content' to 1
        )
        pusher.push(notification)
      else
        data = { message: message }.merge(custom_data)
        fcm_connection.send([push_notification_token], data: data)
      end
    end
  end
end
