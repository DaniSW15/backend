Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Autenticación
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      delete 'auth/logout', to: 'auth#logout'
      patch 'auth/update_password', to: 'auth#update_password'
      post 'auth/forgot_password', to: 'auth#forgot_password'
      
      # Usuarios
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'me', to: 'users#me'
        end
      end
      
      # EMPLOYEES (en lugar de collaborators)
      resources :employees do
        collection do
          get 'states', to: 'employees#states'
        end
      end
      
      # Palíndromos
      post 'palindrome/check', to: 'palindrome#check'
      
      # Servicios (JSONPlaceholder)
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end
end