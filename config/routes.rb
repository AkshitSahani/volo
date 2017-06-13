Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'}
  devise_scope :user do
     get '/register_type', to: 'users/registrations#register_type', as: 'register_type'
     get '/new_volunteer', to: 'users/registrations#new_volunteer', as: 'new_volunteer'
     get '/new_organization', to: 'users/registrations#new_organization', as: 'new_organization'
     get '/new_resident', to: 'users/registrations#new_resident', as: 'new_resident'
     get '/get_locations', to: 'users/registrations#get_locations', as: 'get_locations'
     get '/edit_volunteer', to: 'users/registrations#edit_volunteer', as: 'edit_volunteer'
     get '/edit_resident', to: 'users/registrations#edit_resident', as: 'edit_resident'
     get '/edit_organization', to: 'users/registrations#edit_organization', as: 'edit_organization'
  end
  root to: "home#index"
  resources :organizations
    get '/organizations/:id/surveys', to: 'organizations#view_surveys', as: 'view_surveys'
    get '/organizations/:id/surveys/:survey_id/assign_locations', to: 'organizations#assign_locations', as: 'assign_locations'
    post '/organizations/:id/surveys/:survey_id/assign', to: 'organizations#assign', as: 'assign'
    get '/organizations/:id/nest_locations', to: 'organizations#nest_locations', as: 'nest_locations'
    get '/organizations/:id/view_locations', to: 'organizations#view_locations', as: 'view_locations'
  resources :locations
  resources :surveys
    get '/surveys/:id/preview', to: 'surveys#preview', as: 'preview'
    post '/surveys/:id/create_responses', to: 'surveys#create_responses', as: 'create_responses'
    get '/surveys/:id/edit_responses', to: 'surveys#edit_responses', as: 'edit_responses'
    post '/surveys/:id/update_responses', to: 'surveys#update_responses', as: 'update_responses'
    get '/surveys/:id/delete_responses', to: 'surveys#delete_responses', as: 'delete_responses'
  resources :residents
  resources :volunteers
    get '/volunteers/:id/organizations/:org_id', to: 'volunteers#view_org', as: 'view_org'
    get '/volunteers/:id/add_organizations', to: 'volunteers#add_organizations', as: 'add_organizations'
    get '/volunteers/:id/add_locations', to: 'volunteers#add_locations', as: 'add_locations'
    post '/volunteers/:id/associate_locations', to: 'volunteers#associate_locations', as: 'associate_locations'
    get '/volunteers/:id/organizations/:org_id/locations/:loc_id/remove_location', to: 'volunteers#remove_location', as: 'remove_vol_location'
    get '/volunteers/:id/organizations/:org_id/locations/:loc_id/add_location', to: 'volunteers#add_vol_location', as: 'add_vol_location'
  resources :responses
  resources :matches
end
