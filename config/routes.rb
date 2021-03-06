# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  get '/user/recieve_email', to: 'users#recieve_email', as: 'recieve_email'
  post '/user/set_email', to: 'users#set_email', as: 'set_email'
  get '/search', to: 'searchs#search'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :attachments, only: %i[destroy]

  resources :rewards, only: %i[index]

  resources :questions, concerns: [:voted] do
    resources :answers, concerns: [:voted], shallow: true do
      patch :mark_as_best, on: :member
      resources :comments, only: %i[create destroy], defaults: { commentable: 'answer' }
    end
    resources :comments, only: %i[create destroy], defaults: { commentable: 'question' }
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
