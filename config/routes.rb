Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:create]
  end
end
