Rails.application.routes.draw do
  get "home/index"
  root "home#index"

  resources :classlists
  resources :sections
  resources :subjects
  resources :laboratories
  resources :teachers do
    delete :remove_subject, on: :member
  end
  resources :students do
    collection do
      get  :import, action: :new_import
      post :import, action: :create_import
    end
  end
  resources :departments
end
