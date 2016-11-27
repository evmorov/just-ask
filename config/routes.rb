Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: [:edit, :update] do
    resources :answers, only: [:create, :update]
  end

  resources :answers, only: [:destroy] do
    post :best
  end
end
