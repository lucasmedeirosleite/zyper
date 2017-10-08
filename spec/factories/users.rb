# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    username 'user@test.com'
    password 'password'
    access_token 'token'
    expires_in 604_800
  end
end
