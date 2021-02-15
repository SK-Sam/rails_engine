Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: :show
      namespace :merchants do
        resources :search, only: :index
      end
    end
  end
end
