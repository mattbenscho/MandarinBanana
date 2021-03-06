Mbv2::Application.routes.draw do
  match '/mnemonics/:id/images/new', to: 'images#new', via: 'get'
  match '/:parent/:id/mnemonics/new', to: 'mnemonics#new', via: 'get'
  match '/wallposts/:id/new', to: 'wallposts#new', via: 'get'
  match '/featured_images/:id/new', to: 'featured_images#new', via: 'get'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :subtitles
  resources :comments, only: [:index, :create, :destroy]
  resources :movies, only: [:index]
  resources :hanzis
  resources :gorodishes, only: [:show, :index]
  resources :images
  resources :mnemonics
  resources :pinyindefinitions
  resources :wallposts, only: [:index, :create, :destroy]
  resources :featured_images
  resources :strokeorders, only: [:new, :create, :show, :destroy]
  root  'static_pages#home'
  match '/signup',                   to: 'users#new',           via: 'get'
  match '/signin',                   to: 'sessions#new',        via: 'get'
  match '/signout',                  to: 'sessions#destroy',    via: 'delete'
  match '/about',                    to: 'static_pages#about',  via: 'get'
  match '/search',                   to: 'hanzis#search',       via: 'get'
  match '/hurl/:input',              to: 'hanzis#hurl',         via: 'get'
  match '/select/:character',        to: 'hanzis#select',       via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
