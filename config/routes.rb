Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  resources :organizations
  resources :locations
  resources :surveys
    get '/surveys/:id/preview_rank', to: 'surveys#preview_rank', as: 'preview_rank'
    post '/surveys/:id/rank_survey', to: 'surveys#rank_survey', as: 'rank_survey'
  resources :residents
  resources :volunteers
  resources :responses


end
