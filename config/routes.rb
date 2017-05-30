Rails.application.routes.draw do
  
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  
  resources :history_clients
  resources :templates  do
    member {
      get :send_mail
      post :send_mail_confirm
      resources :email_histories
    }
  end

  resources :email_histories, only:[] do
    member {
      get :send_email
      post :send_mail_confirm
    }
  end
  
  resources :assignments do
    member do
      get :complete_assignment
      get :pdf_assignment
    end
  end
  resources :routes  do
    member do
      get :manage_branches
      get :get_route_branches
    end
    collection do
      get :schedules
    end
  end
  resources :route_branches, only:[:show] do
    collection do
      post 'sort'
    end
  end
  resources :roles
  resources :cities do
    member do
      get :get_city_areas
    end
  end
  resources :states do
    resources :cities, only:[] do
      collection do
        get :get_state_cities
      end
    end
  end
  
  resources :products do
    collection do
      post 'sort'
    end
  end
 
 
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
  resources :areas do
    collection do
      get :get_area_branches
    end
  end
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
  
  resources :branches do
    member do
      post :update_branch_status
    end
  end
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
