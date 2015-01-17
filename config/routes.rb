Rails.application.routes.draw do
  root 'offers#new'

  resources :offers, only: [:new] do
    collection do
      post :search
    end
  end
end
