Megatombike::Application.routes.draw do
  post "race_teams/add_rider"
  post "race_teams/remove_rider"
  post "race_teams/update_chosen"
 
  match "race_teams/new/:team_id/race/:race_id" => "race_teams#new", :via => :get
  match "race_teams/:team_id/race/:race_id" => "race_teams#create", :via => :post
  match "race_teams/edit/:team_id/race/:race_id" => "race_teams#new", :via => :get
  match "race_teams/:team_id/race/:race_id" => "race_teams#update", :via => :put

  resources :race_teams, :only => [:index, :show, :destroy]
  resources :categories
  resources :races

  post "teams/add_rider"
  post "teams/remove_rider"

  post "riders/search"
  get "subscribe/index"

  resources :riders
  resources :cycling_teams
  resources :teams, :only => [:index, :new, :create, :destroy]

  devise_for :users, :controllers => { :registrations => "registrations" }

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
  root :to => 'subscribe#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
