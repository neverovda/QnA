Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :voteable do
    member do
      post :like
      post :dislike
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: [:voteable, :commentable], shallow: true do
    resources :comments, only: :create 
    resources :answers, concerns: [:voteable], except: [:show, :index] do
      post :best, on: :member
    end    
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :badges, only: :index

  mount ActionCable.server => '/cable'

end
