# frozen_string_literal: true

# Public: Model which represens a video
class Video
  include ActiveModel::Model

  attr_reader :id, :title, :thumbnail, :subscription_required

  def initialize(options = {})
    @id = options['_id']
    @title = options['title']
    @thumbnail = options.try(:[], 'thumbnails').try(:[], 0).try(:[], 'url')
    @subscription_required = options['subscription_required']
  end
end
