# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authenticator do
  subject(:authenticator) do
    described_class.new(client: client)
  end

  let(:client) { double(:client) }
  let(:now) { Time.new(2017, 7, 1, 12, 0, 0) }

  before { Timecop.freeze(now) }
  after { Timecop.return }
  
  describe '#authenticate' do
    subject(:authenticate) { authenticator.authenticate(params) }
    let(:params) do
      { username: username, password: password }
    end
    let(:username) { 'email@example.com' }
    let(:password) { 'password1' }

    before do
      allow(client).to receive(:login)
        .with(username: username, password: password)
        .and_return(user_response)
    end

    context 'when not in database' do
      let(:user) { nil }

      context 'with invalid credentials' do
        let(:user_response) do
          double(:response, status: :unauthorized, content: double(:content))
        end

        it 'does not find any user' do
          expect(authenticate).to be_nil
        end
      end

      context 'with valid credentials' do
        let(:user_response) do
          double(:response, status: :ok, content: content)
        end
        let(:content) do
          { 
            'access_token' => '123',
            'token_type' => 'bearer',
            'expires_in' => 123,
            'refresh_token' => '321',
            'scope' => 'consumer',
            'created_at' => 1234
          }
        end

        it 'returns an User' do
          expect(authenticate).to be_a(User)
        end

        it 'creates a new entry for the user' do
          expect { authenticate }.to change { User.count }.by(1)
        end
      end
    end

    context 'when in database' do
      context 'with invalid credentials' do
        let(:user_response) { double(:response, status: :unauthorized, content: double(:content)) }
        let(:invalid) { 'invalidpass' }
        
        before do
          FactoryGirl.create(:user, username: username, password: invalid)
        end

        it 'does not authenticate' do
          expect(authenticate).to be_nil
        end
      end

      context 'with valid credentials' do
        let(:user_response) { double(:user_response) }

        before do
          FactoryGirl.create(:user, username: username, password: password, created_at: creation_date)
        end

        context 'when ttl not reached' do
          let(:creation_date) { now }

          it 'returns the user from the database database' do
            expect(client).not_to receive(:login)
            expect(authenticate).to be_a(User)
          end
        end
        
        context 'when ttl reached' do
          let(:creation_date) { now - 5.days }

          let(:user_response) do
            double(:response, status: :ok, content: content)
          end
          let(:content) do
            { 
              'access_token' => '123',
              'token_type' => 'bearer',
              'expires_in' => 123,
              'refresh_token' => '321',
              'scope' => 'consumer',
              'created_at' => 1234
            }
          end

          before do
            allow_any_instance_of(User).to receive(:new_token?).and_return(false)
          end

          it 'returns an User' do
            expect(authenticate).to be_a(User)
          end

          it 'updates the previous user model' do
            expect { authenticate }.not_to change { User.count }
          end
        end
      end
    end
  end
end