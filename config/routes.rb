Rails.application.routes.draw do

  # auth routing
  post 'auth/login'
  get 'auth/logout'
  get 'auth/get_session'
  post 'signup', to: 'signup#index'
  post 'signup/index'

  # todos routing
  get 'todos/index'
  post 'todos/create'
  get 'todos/show'
  put 'todos/update'
  delete 'todos/delete'
  get 'todos', to: 'todos#index'
  post 'todos', to: 'todos#create'
  get 'todos/:id', to: 'todos#show'
  put 'todos/:id', to: 'todos#update'
  delete 'todos/:id', to: 'todos#delete'

  # todo items
  get 'todo_items/show'
  get 'todo_items/delete'
  get 'todo_items/update'
  get 'todo_items/create'
  get '/todos/:id/items', to: 'todo_items#show'
  put '/todos/:id/items', to: 'todo_items#update'
  delete '/todos/:id/items', to: 'todo_items#delete'
  post '/todos/:id/items', to: 'todo_items#create'


  resources :users

end
