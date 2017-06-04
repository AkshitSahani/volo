Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  resources :organizations
    get '/organizations/:id/surveys', to: 'organizations#view_surveys', as: 'view_surveys'
    get '/organizations/:id/surveys/:survey_id/assign_locations', to: 'organizations#assign_locations', as: 'assign_locations'
    post '/organizations/:id/surveys/:survey_id/assign', to: 'organizations#assign', as: 'assign'
  resources :locations
  resources :surveys
    get '/surveys/:id/preview', to: 'surveys#preview', as: 'preview'
    post '/surveys/:id/create_responses', to: 'surveys#create_responses', as: 'create_responses'
  resources :residents
  resources :volunteers
    get '/volunteers/:id/organizations', to: 'volunteers#view_organizations', as: 'view_organizations'
    get '/volunteers/:id/add_organizations', to: 'volunteers#add_organizations', as: 'add_organizations'
    get '/volunteers/:id/add_locations', to: 'volunteers#add_locations', as: 'add_locations'
    post '/volunteers/:id/associate_locations', to: 'volunteers#associate_locations', as: 'associate_locations'
  resources :responses
  resources :matches
end
