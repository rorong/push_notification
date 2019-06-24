# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PushNotificationsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'POST #send_message' do
    it 'send a push notification message' do
      post :send_message, params: { push_notification: FactoryBot.attributes_for(:push_notification) }
      expect(response).to redirect_to(root_path)
    end
  end
end
