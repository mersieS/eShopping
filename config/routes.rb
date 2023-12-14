Rails.application.routes.draw do

  namespace "api" do
      resources :products do
        collection do
            get 'get_by_name'
        end
      end
      
      resources :categories do
        collection do
          get 'get_by_name'
        end
      end

      resources :carts do
        collection do
          get 'provide'
          post 'add_cart'
          delete 'remove_cart'
        end
      end

      resources :orders do
        collection do
          get 'get_by_username'
          post 'set_order_status'
          post 'cancel_order'
        end
      end

      resources :users do
        collection do
          patch 'change_role'
        end
      end
  end

  scope 'api' do
    mount_devise_token_auth_for 'User', at: 'auth'
  end
end
