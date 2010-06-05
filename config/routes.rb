ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :users, :collection => { :password_forgot => [:get, :post] }, 
                        :member => {
                          :reset_password => :get, 
                          :do_reset_password => :put
                        }
  map.resource :session
  
  map.resources :categories

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

  map.namespace :admin do |admin|
    admin.resource :status
    admin.resources :users, :member => { :restart_time => :get } do |user|
      user.resources :runs, :member => {
        :queue => :get
      }, :collection => {
        :queue => :get
      }
    end
    
    admin.resources :contests do |contests|
      contests.resources :runs, :member => {
        :queue => :get
      }, :collection => {
        :queue => :get
      }
      contests.resources :problems, :member => { 
        :purge_files => :get, 
        :download_file => :get, 
        :upload_file => :get, 
        :do_upload_file => :post
      } do |problem|
        problem.resources :runs, :member => {
          :queue => :get
        }, :collection => {
          :queue => :get
        }
      end
    end

    admin.resources :categories
    admin.resources :messages
    admin.resource :reports
    admin.resource :ratings, :member => { :recalculate => :post }
    admin.resources :external_contests, :member => { :rematch => :post, :remove_links => :post } do |x_contests|
      x_contests.resources :external_contest_results, :member => { :remove_user => :post }
    end
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "main"
  
  map.practice '/practice/:action', { :controller => :practice }

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
