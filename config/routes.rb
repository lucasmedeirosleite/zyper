# frozen_string_literal: true

Rails.application.routes.draw do
  root 'videos#index'

  resources :videos, only: [:index, :show]
  resources :sessions, only: [:new, :create]
end
