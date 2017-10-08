# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'

gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'materialize-sass', '~> 0.100.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'mongoid', '~> 6.2', '>= 6.2.1'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'

gem 'zype_sdk', github: 'lucasmedeirosleite/zype-sdk', branch: 'master'

group :development, :test do
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'rubocop', '~> 0.50.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'coveralls'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'mongoid-rspec', github: 'mongoid-rspec/mongoid-rspec'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
