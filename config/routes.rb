Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      # Authentication routes
      post 'auth/login', to: 'auth#login'
      post 'auth/signup', to: 'auth#signup'
      
      # User routes
      resources :users, only: [:index, :show, :create, :update, :destroy]
      get 'users/profile', to: 'users#profile'
      
      # Credits
      get 'credits/balance', to: 'credit_transactions#balance'
      
      # Settings
      put 'settings', to: 'settings#update'
      
      # Surveys#index metodu hem köklü hem de iç içe rotaları desteklediği için 
      # :surveys, only: [:index] rotasını tutmak mantıklıdır.
      # Update, show ve destroy için de route ekliyoruz
      resources :surveys, only: [:index, :show, :update, :destroy] 

      resources :scales do
        # SurveysController#create metodu :scale_id'yi beklediği için iç içe kalmalıdır.
        resources :surveys, shallow: true do 
          # ResponsesController metotları için iç içe rota (create, index) ve 
          # shallow rotalar (show, update, destroy) sağlanır.
          resources :responses, only: [:index, :create, :show, :update, :destroy]
          # Questions için route'lar
          resources :questions, only: [:create, :destroy]
        end
      end
      
      resources :credit_transactions, only: [:index] 
      
      # AnalysisController'daki potansiyel hataları (ActiveRecord::RecordNotFound) 
      # gidermeniz şartıyla rotalar uygundur.
      resources :analysis, only: [:index, :create, :show, :destroy]
      
      # Survey responses endpoint (flat route for frontend compatibility)
      post 'survey_responses', to: 'responses#create_flat'
      
    end
  end
end