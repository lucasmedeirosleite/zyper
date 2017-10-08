# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #videos' do
    subject(:get_videos) do
      get :index
    end

    let(:videos) { [] }

    before do
      allow_any_instance_of(VideosRepository).to receive(:all).and_return(videos)
    end

    it 'renders index template' do
      get_videos
      expect(response).to render_template(:index)
    end

    context 'when has no videos' do
      let(:videos) { [] }

      it 'assings an empty array of videos' do
        get_videos
        expect(assigns[:videos]).to be_empty
      end
    end

    context 'when there are videos' do
      let(:videos) do
        [
          double(:video, id: 1, title: 'A title 1', thumbnail: 'http://service.com/1.jpg'),
          double(:video, id: 2, title: 'A title 2', thumbnail: 'http://service.com/2.jpg')
        ]
      end

      it 'assigns videos to the view' do
        get_videos
        expect(assigns[:videos]).to eq(videos)
      end
    end
  end
end