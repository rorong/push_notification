# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    platform { 'MyString' }
    device_token { 'MyString' }
  end
end
