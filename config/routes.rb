Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}
  root to: "home#index"
  resources :organizations
    get '/organizations/:id/surveys', to: 'organizations#view_surveys', as: 'view_surveys'
    get '/organizations/:id/surveys/:survey_id/assign_locations', to: 'organizations#assign_locations', as: 'assign_locations'
    post '/organizations/:id/surveys/:survey_id/assign', to: 'organizations#assign', as: 'assign'
    get '/organizations/:id/nest_locations', to: 'organizations#nest_locations', as: 'nest_locations'
  resources :locations
  resources :surveys
    get '/surveys/:id/preview', to: 'surveys#preview', as: 'preview'
    post '/surveys/:id/create_responses', to: 'surveys#create_responses', as: 'create_responses'
  resources :residents
  resources :volunteers
    get '/volunteers/:id/organizations/:org_id', to: 'volunteers#view_org', as: 'view_org'
    get '/volunteers/:id/add_organizations', to: 'volunteers#add_organizations', as: 'add_organizations'
    get '/volunteers/:id/add_locations', to: 'volunteers#add_locations', as: 'add_locations'
    post '/volunteers/:id/associate_locations', to: 'volunteers#associate_locations', as: 'associate_locations'
  resources :responses
  resources :matches
end
