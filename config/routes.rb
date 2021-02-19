Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#find', as: 'find_one'
        get '/most_revenue', to: 'revenues#most_revenue', as: 'most_revenue'
      end
      namespace :items do
        get '/find_all', to: 'search#find_all', as: 'find_all'
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        scope module: 'items' do
          resources :merchant, only: :index
        end
      end
      resources :merchants, only: [:index, :show] do
        scope module: 'merchants' do
          resources :items, only: :index
        end
      end
    end
  end
end
