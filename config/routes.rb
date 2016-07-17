require 'sidekiq/web'

MaycampArena::Application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end if Rails.env.production?

  mount Sidekiq::Web, at: '/sidekiq'

  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/login', to: 'sessions#new', as: 'login'
  get '/register', to: 'users#create', as: 'register'
  get '/signup', to: 'users#new', as: 'signup'

  get '/activity', to: 'main#activity', as: 'activity'
  get '/rankings', to: 'main#rankings', as: 'rankings'
  get '/rankings_practice', to: 'main#rankings_practice', as: 'rankings_practice'
  get '/status', to: 'main#status', as: 'status'
  get '/rules', to: 'main#rules'
  get '/main/results', to: 'main#results'

  resources :problems, only: [:index]
  resources :problem_runs, only: [:show]

  resources :users do
    collection do
      get :password_forgot
      post :password_forgot
    end

    member do
      get :reset_password
      patch :do_reset_password
    end
  end

  resource :session

  resources :categories
  resources :groups

  namespace :admin do
    resource :status
    resources :users do
      member do
        get :restart_time
        post :impersonate
      end

      resources :runs do
        member do
          get :queue
        end
        collection do
          get :queue
        end
      end
    end

    resources :contests do
      member do
        get :download_sources
      end

      resources :runs do
        member do
          get :queue
        end
        collection do
          get :queue
        end
      end

      resources :problems do
        member do
          get :purge_files
          get :download_file
          get :upload_file
          get :compile_checker
          put :toggle_runs_visible
          post :do_upload_file
        end
        resources :runs do
          member do
            get :queue
          end

          collection do
            get :queue
          end
        end
      end
    end

    resources :groups
    resources :categories
    resource :reports
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  root to: 'main#index'

  %w(practice timed_contest).each do |contest_type|
    resource contest_type, controller: contest_type do
      post :submit_solution
      get :view_source
      get :get_problem_description
      get :open_contest
    end
  end
end
