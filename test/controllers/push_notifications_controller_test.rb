# frozen_string_literal: true

require 'test_helper'

class PushNotificationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get push_notifications_index_url
    assert_response :success
  end
end
