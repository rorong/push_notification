# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'push_notifications/new', type: :view do
  before(:each) do
    assign(:push_notification, PushNotification.new(
                                 message: 'Hello'
                               ))
  end
  it 'renders new push_notification form' do
    render

    assert_select 'form[action=?][method=?]', send_message_path, 'post' do
      assert_select 'input[name=?]', 'push_notification[message]'
    end
  end
end
