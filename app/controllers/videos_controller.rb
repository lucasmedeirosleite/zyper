# frozen_string_literal: true

# Public: Controller to load videos information
class VideosController < ApplicationController
  def index
    @videos = VideosRepository.new.all
  end

  def show
    @video = VideosRepository.new.find(params[:id])
    video_page(@video)
  end

  private

  def video_page(video)
    return redirect_to videos_path, alert: message(video) unless video
    return redirect_to new_session_path, notice: message(video) if video.subscription_required
    render 'videos/show'
  end

  def message(video)
    return I18n.t('video.not_found') unless video
    I18n.t('video.subscription_required')
  end
end