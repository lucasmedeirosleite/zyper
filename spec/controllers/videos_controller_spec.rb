# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #index' do
    subject(:get_videos) do
      get :index
    end

    let(:videos) { double(:result, data: data, pagination: pagination) }
    let(:data) { [] }
    let(:pagination) { nil }

    before do
      allow_any_instance_of(VideosRepository).to receive(:all).and_return(videos)
    end

    it 'renders index template' do
      get_videos
      expect(response).to render_template(:index)
    end

    context 'when has no videos' do
      it 'assings an empty array of videos' do
        get_videos
        expect(assigns[:videos].data).to be_empty
        expect(assigns[:videos].pagination).to be_nil
      end
    end

    context 'when there are videos' do
      let(:data) do
        [
          double(:video, id: 1, title: 'A title 1', thumbnail: 'http://service.com/1.jpg'),
          double(:video, id: 2, title: 'A title 2', thumbnail: 'http://service.com/2.jpg')
        ]
      end
      let(:pagination) { double(:pagination) }

      it 'assigns videos to the view' do
        get_videos
        expect(assigns[:videos].data).to eq(data)
        expect(assigns[:videos].pagination).to eq(pagination)
      end
    end
  end

  describe 'GET #show' do
    subject(:get_video) do
      get :show, params: { id: video_id }
    end

    let(:video_id) { 'a-video-id' }

    before do
      allow_any_instance_of(VideosRepository).to receive(:find)
        .with(video_id)
        .and_return(video)

      get_video
    end

    context 'when video does no exist' do
      let(:video) { nil }

      it 'redirects to videos page' do
        expect(response).to redirect_to(videos_path)
      end

      it 'sets a flash message saying video not found' do
        expect(flash[:alert]).to eq('Video not found')
      end
    end

    context 'when video exists' do
      let(:video) do
        Video.new('_id' => video_id, 'title' => 'A title', 'subscription_required' => subscription)
      end

      context 'when video does not require subscription' do
        let(:subscription) { false }

        it 'renders the video page' do
          expect(response).to render_template(:show)
        end

        it 'assings video variable' do
          expect(assigns[:video]).to eq(video)
        end
      end

      context 'when video required subscription' do
        let(:subscription) { true }

        it 'redirects to login page' do
          expect(response).to redirect_to(new_session_path)
        end

        it 'set flashs with a login required message' do
          expect(flash[:notice]).to eq('To see the video a login is required')
        end
      end
    end
  end
end
