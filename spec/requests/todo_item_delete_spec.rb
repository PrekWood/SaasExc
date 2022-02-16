require "rails_helper"

describe 'Todo Item Delete Single API', type: :request do

  it 'deletes single todo item' do

    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create a todo
    todo_name = 'todo_1'
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:created)

    # get todo_id
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # create todo items
    todo_text = 'item_content'
    post '/todos/'+todo_id.to_s+'/items?text='+todo_text
    expect(response).to have_http_status(:created)

    # get todo_item_id
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_item_id = JSON.parse(response.body)["items"][0]["id"]

    # deletes
    delete '/todos/'+todo_item_id.to_s+'/items'
    expect(response).to have_http_status(:ok)

    # get todo_item_id
    get '/todos/'+todo_item_id.to_s+'/items'
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to delete single todo item that does not exist' do

    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create a todo
    todo_name = 'todo_1'
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:created)

    # get todo_id
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # delete
    delete '/todos/99999999/items'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to delete single todo item that does not belong to user' do

    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create a todo
    todo_name = 'todo_1'
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:created)

    # get todo_id
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # create todo item
    todo_text = 'item_content'
    post '/todos/'+todo_id.to_s+'/items?text='+todo_text
    expect(response).to have_http_status(:created)

    # get todo_item_id
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_item_id = JSON.parse(response.body)["items"][0]["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # sign in
    email = "user2@gmail.com"
    password = "password2"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # delete
    delete '/todos/'+todo_item_id.to_s+'/items'
    expect(response).to have_http_status(:bad_request)

  end


  it 'tries to delete single todo item whithout loging in' do

    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create a todo
    todo_name = 'todo_1'
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:created)

    # get todo_id
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # create todo item
    todo_text = 'item_content'
    post '/todos/'+todo_id.to_s+'/items?text='+todo_text
    expect(response).to have_http_status(:created)

    # get todo_item_id
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_item_id = JSON.parse(response.body)["items"][0]["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # delete
    delete '/todos/'+todo_item_id.to_s+'/items'
    expect(response).to have_http_status(:bad_request)

  end
end