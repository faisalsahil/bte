Rails.application.routes.draw do
  
  
  resources :areas
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'dashboards#index'
  devise_for :users
  
  resources :dashboards
  resources :companies
  resources :vehicles do
    collection do
      get  'assignment'
      get 'assign_branches'
      get  'get_users'
      post 'assign_vehicle'
      post 'branches_assignment'
      delete 'unassigned_vehicle'
    end
  end
  
  resources :branches
  resources :schedules
  resources :users, only: [:index, :new] do
    collection do
      post 'add_user'
    end
    member do
      delete 'block_unblock_user'
    end
  end
end
