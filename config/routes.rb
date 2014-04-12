MaycampArena::Application.routes.draw do

  match '/logout', :controller => 'sessions', :action => 'destroy', :as => 'logout'
  match '/login', :controller => 'sessions', :action => 'new', :as => 'login'
  match '/register', :controller => 'users', :action => 'create', :as => 'register'
  match '/signup', :controller => 'users', :action => 'new', :as => 'signup'

  match '/activity', :controller => 'main', :action => 'activity', :as => 'activity'
  match '/rankings', :controller => 'main', :action => 'rankings', :as => 'rankings'
  match '/rankings_practice', :controller => 'main', :action => 'rankings_practice', :as => 'rankings_practice'
  match '/status', :controller => 'main', :action => 'status', :as => 'status'
  match '/problems', :controller => 'main', :action => 'problems', :as => 'problems'
  match '/problem_runs/:id', :controller => 'main', :action => 'problem_runs', :as => 'problem_runs'

  resources :users do
    collection do
      get :password_forgot
      post :password_forgot
    end

    member do
      get :reset_password
      post :do_reset_password
    end
  end

  resource :session

  resources :categories

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  namespace :admin do
    resource :status
    resources :users do
      member do
        get :restart_time
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

    resources :categories
    resources :messages
    resource :reports
    resource :ratings do
      member do
        post :recalculate
      end
    end
    resources :external_contests do
      member do
        post :rematch
        post :remove_links
      end

      resources :external_contest_results do
        member do
          post :remove_user
        end
      end
    end
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  root :to => "main#index"

  match '/practice/:action', :controller => :practice, :as => 'practice'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  match ':controller(/:action(/:id))'
  # map.connect ':controller/:action/:id.:format'
end
