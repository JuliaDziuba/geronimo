Makersmoon::Application.routes.draw do

  root to: 'static_pages#home'
  match '/tour', to: 'static_pages#tour'
  match '/features', to: 'static_pages#features'
  match '/pricing',  to: 'static_pages#pricing'
  match '/help',     to: 'static_pages#help'
  match '/export',   to: 'static_pages#export'
  match '/signup',   to: 'users#new'
  match '/signin',   to: 'sessions#new'
  match '/signout',  to: 'sessions#destroy', via: :delete
  match '/PayPal_IPN', to: 'payment_notifications#create'
  match '/payment_notifications/success', to: 'payment_notifications#success'
  match '/payment_notifications/failure', to: 'payment_notifications#failure'

  resource :static_pages, only: [:home, :help]

  resources :users, path: "makers/" do
    member do 
      get :annual
      get :insight
      get :public
      get :about
      get :contact
      get :purchase
      get :work
      get :account
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :activities, exclude: [:edit], path: "internal/works/activities/"
  resources :workcategories , exclude: [:show], path: "/internal/works/categories/"
  resources :works, exclude: [:edit], path: "/internal/works/" do
    collection do
      put :update_multiple
    end
  end
  resources :venues, exclude: [:edit], path: "/internal/venues/"
  resources :clients, exclude: [:edit], path: "/internal/clients/"
  resources :imports, only: [:new, :create]
  resources :documents
  resources :notes do
    collection do
      put :update_multiple
    end
  end

  resources :actions do
    collection do
      put :update_multiple
    end
  end

  resources :questions, only: [:create]


  match '/makers/:user/:workcategory', to: 'users#work', as: 'workcategory_user'
  match '/makers/:user/:workcategory/:work', to: 'users#work', as: 'work_user'

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
  # match ':controller(/:action(/:id))(.:format)'
end
