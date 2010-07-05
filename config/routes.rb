# TODO organize routes better
FmlClone::Application.routes.draw do |map|
  match 'moderators' => 'moderators#index', :as => 'moderators'
  match 'moderators/:id/up_vote' => 'moderators#up_vote', :as => 'moderators_up_vote'
  match 'moderators/:id/down_vote' => 'moderators#down_vote', :as => 'moderators_down_vote'
  
  root :to => "posts#index"
  resource :user_session
  resources :pages
  match 'search' => 'search#index', :as => 'search'
  match 'logout' => 'user_sessions#destroy', :as => 'logout'
  match 'login' => 'user_sessions#new', :as => 'login'
  resource :account, :controller => "users"
  match 'signup' => 'users#new', :as => 'signup'
  match 'account/activate/:activation_code' => 'users#activate', :as => 'activate'
  match 'account/new_activation_email' => 'users#new_activation_email', :as => 'new_activation_email'
  match 'account/send_activation_email' => 'users#send_activation_email', :as => 'send_activation_email'
  match 'account/new_password' => 'password#new', :as => 'new_password'
  match 'account/send_password_reset' => 'password#create', :as => 'send_password_reset'
  match 'account/reset_password/:reset_code' => 'password#edit', :as => 'reset_password'
  match 'account/save_password' => 'password#update', :as => 'save_password'
  match 'posts/:post_id/favorite' => 'favorites#create', :as => 'favorite_post'
  
  match 'posts/top_rated/:time_period' => 'posts#top_rated', :as => 'top_rated_posts'
  match 'posts/top_rated/week' => 'posts#top_rated', :as => 'top_rated_posts_of_week'
  match 'posts/top_rated/month' => 'posts#top_rated', :as => 'top_rated_posts_of_month'
  match 'posts/top_rated/year' => 'posts#top_rated', :as => 'top_rated_posts_of_year'
  match 'posts/top_rated/all' => 'posts#top_rated', :as => 'top_rated_posts_of_all_time'
  
  match 'search' => 'posts#index', :as => 'search'
  
  resources :users do
    resources :favorites
  end
  
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
  match 'admin' => 'admin/posts#index', :as => 'admin'
  namespace :admin do
    resources :posts do
      resources :comments
      member do
        post :publish
        post :unpublish
        post :deny
        post :undeny
        post :get_short_url
        post :delete_short_url
      end
    end
    resources :categories
    resources :users do
      member do
        post :activate
        post :suspend
        post :unsuspend
        post :delete
      end
    end
    resources :preferences do
      collection do
        post :bulk_update
      end
    end
    resources :pages
  end
  
end
