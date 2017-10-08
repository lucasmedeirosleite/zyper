# frozen_string_literal: true

Rails.application.routes.draw do
  root 'videos#index'

  resources :videos, only: %i[index show]
  resources :sessions, only: %i[new destroy] do
    post :create, as: :login, on: :collection
  end
end
