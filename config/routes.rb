Rails.application.routes.draw do
  get 'transactions/payment'

  resources :billings do
    resources :transactions, only: [] do
      collection do
        get 'payment'
        post 'create_payment'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'dashboards#index'
  devise_for :users
  
  resources :dashboards
  resources :companies
  resources :storage_types
  resources :food_types
  resources :areas
  resources :vehicles do
    collection do
      get  'assignment'
      get 'assign_branches'
      get  'get_users'
      post 'assign_vehicle'
      post 'branches_assignment'
      delete 'unassigned_branch'
    end
  end
  
  resources :branches
  resources :schedule_branches, only:[] do
    collection do
      get 'schedules'
    end
    
  end

  resources :collections
  resources :users, only: [:index, :new] do
    collection do
      post 'add_user'
    end
    member do
      delete 'block_unblock_user'
    end
  end
end
