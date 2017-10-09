# frozen_string_literal: true

# Public: Repository used to retrieve videos
class VideosRepository
  def initialize(client: ZypeSDK)
    @client = client
  end

  def all(page: 1)
    response = client.videos(page: page)
    return [] if RESPONSE_STATUSES.include?(response.status)
    videos = videos_from(response.content['response'])
    pagination = pagination(response.content['pagination'])
    VideosResult.new(videos, pagination)
  end

  def find(video_id)
    response = client.video(video_id)
    return if RESPONSE_STATUSES.include?(response.status)
    Video.new(response.content['response'])
  end

  private

  RESPONSE_STATUSES = %i[unauthorized not_found internal_error].freeze

  VideosResult = Struct.new(:data, :pagination)

  attr_reader :client

  def videos_from(response)
    response.map { |video_hash| Video.new(video_hash) }
  end

  def pagination(pagination_hash)
    HashWithIndifferentAccess.new(pagination_hash)
  end
end
