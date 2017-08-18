Rails.application.routes.draw do
    root 'sessions#new'   
    get '/', to: 'sessions#new'
    post '/', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    get '/connection', to: 'connections#show'
    get '/connection/sas', to: 'connections#get_sas'
    get '/connection/configure', to: 'connections#configure'
    get '/connection/configure/:conn_name', to: 'connections#configure'
    post '/connection/update', to: 'connections#update'
    get '/configuration', to: 'configurations#show'
    post '/configuration', to: 'configurations#update'
end
