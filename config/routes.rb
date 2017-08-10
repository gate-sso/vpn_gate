Rails.application.routes.draw do
   get 'welcome/index'
   get 'vpn/index'
   get 'vpn/test'

   resources :connections

   root 'welcome#index'
end
