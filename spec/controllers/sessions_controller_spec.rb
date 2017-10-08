# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    subject(:new_session) { get :new }

    before { new_session }

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns a new user' do
      expect(assigns[:user]).not_to be_nil
    end
  end

  describe 'POST #create' do
    subject(:login) do
      post :create, params: { user: params }
    end
    let(:params) { {} }

    before do
      allow_any_instance_of(Authenticator).to receive(:authenticate)
        .with(params)
        .and_return(user)

      login
    end

    context 'when credentials are invalid' do
      let(:user) { nil }
      let(:params) { { username: 'invalid@example.com', password: 'a-pass' } }

      it 'redirects to login page' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets flash with invalid credentials message' do
        expect(flash[:alert]).to eq('Invalid credentials')
      end
    end

    context 'when credentials are valid' do
      let(:user) { double(:user, id: 'an-id') }
      let(:params) { { username: 'valid@example.com', password: 'a-valid-pass' } }

      it 'redirects to videos page' do
        expect(response).to redirect_to(videos_path)
      end

      it 'sets flash message of success log' do
        expect(flash[:notice]).to eq('Logged in successfully')
      end

      it 'sets user id in session' do
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end
end
