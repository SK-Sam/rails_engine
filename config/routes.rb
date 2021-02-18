Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
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
       namespace :merchants do
        get '/find_one', to: 'search#find_one', as: 'find_one'
      #   scope module: 'merchants' do
      #     resources :search, only: :
      #   end
       end
    end
  end
end
