require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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

  resources :questions, except: %i[edit update], concerns: %i[votable commentable] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, concerns: %i[votable commentable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create], shallow: true
      end
    end
  end

  post :ask_email_oauth, to: 'oauths#ask_email'
  post :ask_username_oauth, to: 'oauths#ask_username'

  %w[questions answers comments users everywhere].each do |action|
    get "search/#{action}" => "searches##{action}"
  end

  mount ActionCable.server => '/cable'
end
