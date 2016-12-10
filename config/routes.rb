Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: [:edit, :update] do
    resources :answers, shallow: true do
      post :best
    end
  end

  resources :attachments, only: [:destroy]

  post 'upvote', controller: 'votes'
end
