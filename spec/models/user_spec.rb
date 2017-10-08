# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:expires_in) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:access_token) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end
end
