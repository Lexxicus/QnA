# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

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
    end
  end

  mount ActionCable.server => '/cable'
end
