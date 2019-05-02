Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats, except: :destroy
  resources :cat_rental_requests, only: [:create, :new] do
    member { post 'approve' }
    member { post 'deny' }
  end
end
