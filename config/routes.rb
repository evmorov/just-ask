Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, except: [:edit, :update], concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
        get :users, on: :collection
      end
    end
  end

  post :ask_email_oauth, to: 'oauths#ask_email'

  mount ActionCable.server => '/cable'
end
