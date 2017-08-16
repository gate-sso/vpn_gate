Rails.application.routes.draw do
   
    get    '/',   to: 'sessions#new'
    post   '/',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'
   
end
