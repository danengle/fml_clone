FmlClone::Application.routes.draw do |map|
  resources :votes


  root :to => "posts#index"
  resource :user_session
  match 'logout' => 'user_sessions#destroy', :as => 'logout'
  match 'login' => 'user_session#new', :as => 'login'
  resource :account, :controller => "users"
  match 'signup' => 'users#new', :as => 'signup'
  match 'account/activate/:activation_code' => 'users#activate', :as => 'activate'
  resources :users
  resources :categories
  resources :posts do
    resources :comments do
      member do
        get :reply
      end
    end
    member do
      post :up_vote
      post :down_vote
    end
    collection do
      get :top_rated
      get :random
    end
  end
  # TODO get this working so posts/top_rated/:time_period is the url
  # match 'posts/top_rated/:time_period' => 'posts#top_rated', :as => 'top_rated'
  match 'admin' => 'admin/categories#index', :as => 'admin'
  namespace :admin do
    resources :posts do
      member do
        post :publish
        post :unpublish
      end
    end
    resources :categories
    resources :users
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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end