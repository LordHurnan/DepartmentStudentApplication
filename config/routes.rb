Rails.application.routes.draw do
  resources :classlists
  resources :sections
  resources :subjects
  resources :laboratories
  resources :teachers do
    delete :remove_subject, on: :member
  end
  resources :students
  resources :departments
end
