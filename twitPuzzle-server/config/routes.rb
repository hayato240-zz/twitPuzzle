TwitPuzzle::Application.routes.draw do
  resources :rankings

  resources :users

  resources :users do
    resources :puzzles
  end
  resources :logins
  resources :friend do
    collection do
      get 'follow'
      get 'follower'
    end
  end

  resources :puzzles do
     member do
      get 'get_image'
     end
   end

resources :users do 
  resources :rankings
end

  resources :users do
    collection do
      get 'self_profile'
    end
  end


  TwitPuzzle::Application.routes.draw do
    get "rankings/eachRanking/:puzzle_id" => "rankings#eachRanking"
  end

  TwitPuzzle::Application.routes.draw do
    get "users/search/:name" => "users#searchID"
  end

  TwitPuzzle::Application.routes.draw do
    get "users/profile/self" => "users#self_profile"
  end

  TwitPuzzle::Application.routes.draw do
    get "puzzles/user/:user_id" => "puzzles#user_puzzle"
  end






  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'logins#new'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
