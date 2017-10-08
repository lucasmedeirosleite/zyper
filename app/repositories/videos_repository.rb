# frozen_string_literal: true

# Public: Repository used to retrieve videos
class VideosRepository
  def initialize(client: ZypeSDK)
    @client = client
  end

  def all
    response = client.videos
    return [] if RESPONSE_STATUSES.include?(response.status)
    videos_from(response.content['response'])
  end

  def find(video_id)
    response = client.video(video_id)
    return if RESPONSE_STATUSES.include?(response.status)
    Video.new(response.content['response'])
  end

  private

  RESPONSE_STATUSES = %i[unauthorized not_found internal_error].freeze

  attr_reader :client

  def videos_from(response)
    response.map { |video_hash| Video.new(video_hash) }
  end
end
