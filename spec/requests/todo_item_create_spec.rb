require "rails_helper"

describe 'Todo Item Create API', type: :request do

  it 'creates todo items' do

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

    # get todos
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_json = JSON.parse(response.body)["todos"][0]
    todo_id = todo_json["id"]

    # create todo item
    post '/todos/'+todo_id.to_s+'/items?text=item_content_1'
    expect(response).to have_http_status(:created)

  end

  it 'tries to create todo item without login' do
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

    # get todos
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_json = JSON.parse(response.body)["todos"][0]
    todo_id = todo_json["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # create todo item
    post '/todos/'+todo_id.to_s+'/items?text=item_content_1'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to create todo item without text' do
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

    # get todos
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_json = JSON.parse(response.body)["todos"][0]
    todo_id = todo_json["id"]

    # create todo item
    post '/todos/'+todo_id.to_s+'/items'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to update todo item to todo what does not belong to user' do

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

    # get todos
    get '/todos'
    expect(response).to have_http_status(:ok)
    todo_json = JSON.parse(response.body)["todos"][0]
    todo_id = todo_json["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # sign in
    email = "user2@gmail.com"
    password = "password2"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create todo item
    post '/todos/'+todo_id.to_s+'/items?text=test'
    expect(response).to have_http_status(:bad_request)

  end

end