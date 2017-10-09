# frozen_string_literal: true

Rails.application.routes.draw do
  root 'videos#index'

  resources :videos, only: %i[index show]
  resources :sessions, only: :new do
    collection do
      post :create, as: :login
      delete :destroy, as: :logout
    end
  end
end
