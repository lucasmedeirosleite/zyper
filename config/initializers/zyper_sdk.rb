# frozen_string_literal

ZypeSDK.configure do |config|
  config.app_key = ENV['ZYPE_APP_KEY']
  config.client_id = ENV['ZYPE_CLIENT_ID']
  config.client_secret = ENV['ZYPE_CLIENT_SECRET']
end
