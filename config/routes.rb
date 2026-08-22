Rails.application.routes.draw do
  resources :laboratories
  resources :teachers
  resources :students
  resources :departments
end
