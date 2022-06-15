Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  concern :voted do
    member do
      post :like
      post :dislike
      delete :cancel
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], shallow: true, only: %i[create update destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  mount ActionCable.server => '/cable'
end
