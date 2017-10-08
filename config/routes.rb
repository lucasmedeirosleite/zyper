# frozen_string_literal: true

Rails.application.routes.draw do
  root 'videos#index'

  resources :videos, only: [:index, :show]
end
