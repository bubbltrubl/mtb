Megatombike::Application.routes.draw do
  get "mobile_version" => "subscribe#force_mobile"
  get "full_version" => "subscribe#force_full"

  get "payments" => "payments#index"
  post "payments/set_paid/:team_id" => "payments#set_paid"
  post "payments/set_unpaid/:team_id" => "payments#set_unpaid"

  get "results/new" => "results#new"
  get "authentications" => "authentication#index"
  delete "authentications/:id" => "authentication#destroy"
  match "auth/:provider/callback" => "authentication#create"
  match "auth/failure" => "authentication#failure"
  post "authentications/use_this" => "authentication#use_this"

  post "results/create/:race_id" => "results#create"
  get "results/:race_id" => "results#index"
  get "results" => "results#index"
  
  resources :my_teams, :only => [:index]
  get "my_teams/:team_id/race/:race_id" => "my_teams#show"
  get "my_teams/:team_id" => "my_teams#show"

  get "teams/filter_period/:period_id" => "teams#filter_period"

  post "race_teams/add_rider"
  post "race_teams/remove_rider"
  post "race_teams/update_chosen"
 
  match "race_teams/new/:team_id/race/:race_id/:rdtmt" => "race_teams#new", :via => :get
  match "race_teams/new/:team_id/race/:race_id" => "race_teams#new", :via => :get
  match "race_teams/:team_id/race/:race_id/:rdtmt" => "race_teams#create", :via => :post
  match "race_teams/:team_id/race/:race_id" => "race_teams#create", :via => :post

  resources :race_teams, :only => [:edit,:update,:index, :destroy]
  resources :categories
  resources :races

  get "teams/filter_twt"
  get "teams/filter_fb"
  post "teams/add_rider"
  post "teams/remove_rider"

  post "riders/result_search"
  post "riders/search"
  get "subscribe/index"
  get "subscribe/finished"
  get "subscribe/reglement"

  resources :riders
  resources :cycling_teams
  resources :teams, :only => [:index, :new, :create, :destroy, :show]

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
