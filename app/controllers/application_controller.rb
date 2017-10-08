# frozen_string_literal: true

# Public: Base Application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
