# frozen_string_literal: true

# Public: Class responsible to authenticate user with zype
class Authenticator
  def initialize(client: ZypeSDK, repository: UsersRepository.new)
    @client = client
    @repository = repository
  end

  RESPONSE_STATUS = %i(unauthorized internal_error)

  def authenticate(params)
    if user = authenticate_with_database(params)
      user
    else
      response = authenticate_with_client(params)
      return if RESPONSE_STATUS.include?(response.status)
      save_user(params, response.content)
    end
  end

  private

  attr_reader :client, :repository

  def authenticate_with_client(params)
    client.login(username: params[:username], password: params[:password])
  end

  def authenticate_with_database(params)
    user = repository.find_by_username(params[:username])
    return user.authenticate(params[:password]) if user && user.new_token?
  end

  def save_user(params, response_params)
    response_params.delete('created_at')
    user_params = HashWithIndifferentAccess.new(params.merge(response_params))
    repository.save(user_params)
  end
end