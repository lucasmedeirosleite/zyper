# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosRepository, type: :repositories do
  subject(:repository) { VideosRepository.new(client: client) }

  let(:client) { double(:client) }

  describe '#all' do
    subject(:all) { repository.all }

    before do
      allow(client).to receive(:videos).and_return(videos)
    end

    context 'when unauthorized' do
      let(:videos) do
        double(:response, status: :unauthorized, content: double(:content))
      end

      it 'returns an empty collection of videos' do
        expect(all).to be_empty
      end
    end

    context 'when internal error' do
      let(:videos) do
        double(:response, status: :internal_error, content: double(:content))
      end

      it 'returns an empty collection of videos' do
        expect(all).to be_empty
      end
    end

    context 'when there is no videos' do
      let(:videos) do
        double(:response, status: :ok, content: response)
      end
      let(:response) do
        { 'response' => [], 'pagination' => nil }
      end

      it 'returns an empty collection of videos' do
        expect(all.data).to be_empty
        expect(all.pagination).to be_empty
      end
    end

    context 'when there is some videos' do
      let(:videos) do
        double(:response, status: :ok, content: response)
      end
      let(:response) do
        {
          'response' => [video],
          'pagination' => pagination
        }
      end
      let(:video) do
        {
          '_id' => '1',
          'title' => 'A title',
          'subscription_required' => false,
          'thumbnails' => images
        }
      end
      let(:images) do
        [
          { 'url' => 'http://service.com/1.jpg' }
        ]
      end
      let(:pagination) do
        {
          'current' => 1,
          'previous' => nil,
          'next' => nil,
          'per_page' => 10,
          'pages' => 1
        }
      end

      it 'returns a collection of videos' do
        all.data.each do |video|
          expect(video).to be_a(Video)
          expect(video.id).not_to be_empty
          expect(video.title).not_to be_empty
          expect(video.thumbnail).not_to be_empty
          expect(video.subscription_required).not_to be_nil
        end

        expect(all.pagination).to eq(pagination)
      end
    end
  end

  describe '#find' do
    subject(:find_video) do
      repository.find(video_id)
    end

    let(:video_id) { 'a-video-id' }

    before do
      allow(client).to receive(:video).with(video_id).and_return(video)
    end

    context 'when unauthorized' do
      let(:video) do
        double(:response, status: :unauthorized, content: double(:content))
      end

      it 'returns no video' do
        expect(find_video).to be_nil
      end
    end

    context 'when internal error' do
      let(:video) do
        double(:response, status: :internal_error, content: double(:content))
      end

      it 'returns no video' do
        expect(find_video).to be_nil
      end
    end

    context 'when there is no video' do
      let(:video) do
        double(:response, status: :not_found, content: double(:content))
      end

      it 'returns no video' do
        expect(find_video).to be_nil
      end
    end

    context 'when there is a video' do
      let(:video) do
        double(:response, status: :ok, content: response)
      end
      let(:response) do
        {
          'response' => data
        }
      end
      let(:data) do
        {
          '_id' => '1',
          'title' => 'A title',
          'subscription_required' => false,
          'thumbnails' => images
        }
      end
      let(:images) do
        [
          { 'url' => 'http://service.com/1.jpg' }
        ]
      end

      it 'returns a video' do
        video = find_video
        expect(video).to be_a(Video)
        expect(video.id).not_to be_empty
        expect(video.title).not_to be_empty
        expect(video.thumbnail).not_to be_empty
        expect(video.subscription_required).not_to be_nil
      end
    end
  end
end
