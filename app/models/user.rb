# frozen_string_literal: true

# Public: user model
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  field :username, type: String
  field :expires_in, type: Integer
  field :access_token, type: String
  field :password_digest, type: String

  has_secure_password

  validates_presence_of :username
  validates_uniqueness_of :username

  def new_token?
    (Time.now.to_i - created_at.to_i) < expires_in
  end
end
