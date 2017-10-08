# frozen_string_literal: true

# Public: Base Application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  private

  def reset_current_user
    @current_user = nil
  end
end
