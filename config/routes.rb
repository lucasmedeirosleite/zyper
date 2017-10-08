# frozen_string_literal: true

Rails.application.routes.draw do
  root 'videos#index'

  resources :videos, only: [:index, :show]
  resources :sessions, only: :new do
    post :create, as: :login, on: :collection
  end
end
