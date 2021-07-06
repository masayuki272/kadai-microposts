Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end

  resources :microposts, only: [:create, :destroy]
# ログインユーザーがフォロー、アンフォローできるようにするルーティング
  resources :relationships, only: [:create, :destroy]
# ログインユーザがお気に入りを登録できる[m
  resources :favorites, only: [:create, :destroy]
end