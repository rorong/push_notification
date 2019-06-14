# frozen_string_literal: true

# Migration file for create push notification
class CreatePushNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :push_notifications do |t|
      t.string :message

      t.timestamps
    end
  end
end
