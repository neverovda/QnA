Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :voteable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: [:voteable], shallow: true do
    resources :answers, except: [:show, :index] do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :badges, only: :index

end
