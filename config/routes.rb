Api::Application.routes.draw do
 
  match "docs/" => "home#docs"
  match '/' => redirect("/docs")
  
  match "/index.html" => redirect("/docs")
  
  match "query_test/" => "query_test#index"
  
  get "home/gist"
  
  get "services/insertCall"
  get "services/uploadAudio"
  get "services/insertUser"
  get "services/insertGroup"
  get "services/insertComment"
  get "services/insertTag"
  get "services/updateCallDetail"
  get "services/updateUser"
  get "services/updateGroup"
  get "services/deleteRecord"
  get "services/getCallDetails"
  get "services/getGroups"
  get "services/getSubscriptionInfo"
  get "services/getUsers"
  
  post "services/insertCall"
  post "services/insertUser"
  post "services/insertGroup"
  post "services/insertComment"
  post "services/insertTag"
  post "services/updateCallDetail"
  post "services/updateUser"
  post "services/updateGroup"
  post "services/getCallDetails"
  post "services/getGroups"
  post "services/getSubscriptionInfo"
  post "services/getUsers"
  post "services/deleteRecord"
  post "services/uploadAudio"
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
