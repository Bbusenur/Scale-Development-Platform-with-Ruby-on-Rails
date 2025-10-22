Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      
      resources :surveys, only: [:index] 

      resources :scales do
        resources :surveys, shallow: true do 
          resources :responses, only: [:index, :create, :show, :update, :destroy] 
        end
      end
      
      # Diğer rotalarınız...
      resources :users, only: [:index, :show, :create, :update, :destroy] 
      resources :credit_transactions, only: [:index] 
      resources :analysis, only: [:create, :show]
      
    end
  end
end