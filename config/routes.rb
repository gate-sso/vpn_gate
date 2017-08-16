Rails.application.routes.draw do
    root   'sessions#new'   
    get    '/',   to: 'sessions#new'
    post   '/',   to: 'sessions#create'
    get    '/admin',   to: 'sessions#admin'
    delete '/logout',  to: 'sessions#destroy'
   
end
