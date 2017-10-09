# frozen_string_literal: true

# Public: Repository to retrieve user information
class UsersRepository
  def initialize(base_model: User)
    @base_model = base_model
  end

  def find_by_username(username)
    base_model.find_by(username: username)
  end

  def save(params)
    user = find_by_username(params[:username])
    return base_model.create(params) unless user

    user.update_attributes(params)
    user.reload
  end

  private

  attr_reader :base_model
end
