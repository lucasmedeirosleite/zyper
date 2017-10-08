# frozen_string_literal: true

# Public: Authentication mechanism controller
class SessionsController < ApplicationController
  def new
    return redirect_to videos_path if current_user 
    @user = User.new
  end

  def create
    if user = Authenticator.new.authenticate(user_params.to_h)
      session[:user_id] = user.id
      redirect_to videos_path, notice: I18n.t('user.login_success')
    else
      redirect_to new_session_path, alert: I18n.t('user.invalid_credentials')
    end
  end

  def destroy
    reset_session
    reset_current_user
    redirect_to videos_path, notice: I18n.t('user.logout_success')
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end