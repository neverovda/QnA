Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, shallow: true do
    resources :answers, except: [:show, :index] do
      post :best, on: :member
    end
  end
end
