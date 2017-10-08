# frozen_string_literal: true

# Public: Repository used to retrieve videos
class VideosRepository
  def initialize(client: ZypeSDK)
    @client = client
  end

  def all
    response = client.videos
    case response.status
    when :unauthorized, :internal_error
      []
    else
      videos_from(response.content['response'])
    end
  end

  private

  attr_reader :client

  def videos_from(response)
    response.map { |video_hash| Video.new(video_hash) }
  end
end