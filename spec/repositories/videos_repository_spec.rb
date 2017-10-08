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
        expect(all).to be_empty
      end
    end

    context 'when there is some videos' do
      let(:videos) do
        double(:response, status: :ok, content: response)
      end
      let(:response) do
        {
          'response' => [ video ],
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
          'current': 1,
          'previous': nil,
          'next': nil,
          'per_page': 10,
          'pages': 1
        }
      end

      it 'returns a collection of videos' do
        all.each do |video|
          expect(video).to be_a(Video)
          expect(video.id).not_to be_empty
          expect(video.title).not_to be_empty
          expect(video.thumbnail).not_to be_empty
          expect(video.subscription_required).not_to be_nil
        end
      end
    end
  end
end