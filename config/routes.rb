Lotl::Application.routes.draw do

  get "whatsandwhys" => 'info#whatsandwhys', :as => 'whats_and_whys'

  match "/home" => 'entrance#home', :via => 'get', :as => 'home'
  match "/login" => 'entrance#login', :via => 'post', :as => 'login'
  match "/activation_instructions" => "entrance#activation_instructions", :via => 'get', :as => 'activation_instructions'
  match "/activate" => "entrance#activate", :via => 'get', :as => 'activate'

  resources :users, :only => [:new, :create]
  resources :feedback, :only => [:new, :create]

  resources :projects do
    resources :tasks
    resources :collaborators, :only => [:create, :destroy]
    resources :statistics, :only => [:index, :show]
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "entrance#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end


# error: forgot to add : before keys in a map declaration
# error: added = between a map key and value
# error: did not add anything between a map key and value
