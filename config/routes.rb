Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#find', as: 'find_one'
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
