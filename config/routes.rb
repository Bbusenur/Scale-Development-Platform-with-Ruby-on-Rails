Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      # Surveys#index metodu hem köklü hem de iç içe rotaları desteklediği için 
      # :surveys, only: [:index] rotasını tutmak mantıklıdır.
      resources :surveys, only: [:index] 

      resources :scales do
        # SurveysController#create metodu :scale_id'yi beklediği için iç içe kalmalıdır.
        resources :surveys, shallow: true do 
          # ResponsesController metotları için iç içe rota (create, index) ve 
          # shallow rotalar (show, update, destroy) sağlanır.
          resources :responses, only: [:index, :create, :show, :update, :destroy] 
        end
      end
      
      resources :users, only: [:index, :show, :create, :update, :destroy] 
      resources :credit_transactions, only: [:index] 
      
      # AnalysisController'daki potansiyel hataları (ActiveRecord::RecordNotFound) 
      # gidermeniz şartıyla rotalar uygundur.
      resources :analysis, only: [:index, :create, :show]
      
    end
  end
end