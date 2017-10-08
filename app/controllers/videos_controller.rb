# frozen_string_literal: true

# Public: Controller to load videos information
class VideosController < ApplicationController
  def index
    @videos = VideosRepository.new.all
  end
end