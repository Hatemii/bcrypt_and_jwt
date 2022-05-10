Rails.application.routes.draw do
  resources :users

  post :login, to: "auth#login"
  get :logged_in, to: "auth#logged_in"
  delete :logout, to: "auth#logout"
end
