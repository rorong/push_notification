# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendMessageWorker, type: :job do
  describe '#perform job' do
    context 'instead of pushing jobs to Redis, Sidekiq pushes them
     into a jobs array which you can access' do
      let(:push_notification) { FactoryBot.create(:push_notification, message: 'Testing Message') }
      it 'testing worker queueing (fake)', job: true do
        expect do
          %w[android iOS].map do |platform|
            user = FactoryBot.create(:user, platform: platform, device_token: device_token)
            SendMessageWorker.perform_async(user.platform, user.device_token, push_notification.message)
          end
        end.to change(SendMessageWorker.jobs, :size).by(2)
        # size increase by 2 one for android device and second
        # for ios device
        SendMessageWorker.drain
      end
    end
  end
end
