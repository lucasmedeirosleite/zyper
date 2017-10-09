# frozen_string_literal: true

# Public: Controller to load videos information
class VideosController < ApplicationController
  def index
    @videos = VideosRepository.new.all(page: params[:page] || 1)
  end

  def show
    @video = VideosRepository.new.find(params[:id])
    render_video_page
  end

  private

  attr_reader :video

  def render_video_page
    return redirect_to videos_path, alert: message unless video
    return redirect_to new_session_path, notice: message if cannot_render_page?
    render 'videos/show'
  end

  def message
    return I18n.t('video.not_found') unless video
    I18n.t('video.subscription_required')
  end

  def cannot_render_page?
    video.subscription_required && !current_user
  end
end
