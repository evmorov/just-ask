Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  resources :questions, except: [:edit, :update], concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
end
