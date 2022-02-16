require "rails_helper"

describe 'Todo Delete API', type: :request do

  it 'deletes todo and its items' do

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

    # create todo items
    for i in 0..5
      post '/todos/'+todo_id.to_s+'/items?text=item_content_'+i.to_s
      expect(response).to have_http_status(:created)
    end

    # get todos items
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_items = JSON.parse(response.body)["items"]

    # delete todo
    delete '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)

    # try to get todo
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:bad_request)

    # try to get todo items
    for item in todo_items
      get '/todos/'+item['id'].to_s+'/items'
      expect(response).to have_http_status(:bad_request)
    end
  end

  it 'deletes todo without items' do

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
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # delete todo
    delete '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)

    # try to get todo
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to delete todo when not logged in' do

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
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # delete todo
    delete '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to delete todo that does not exist' do

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
    todo_id = JSON.parse(response.body)["todos"][0]["id"]


    # delete todo
    delete '/todos/999999999'
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to delete todo that does not belong to user' do

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
    todo_id = JSON.parse(response.body)["todos"][0]["id"]

    # logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)

    # sign in
    email = "user2@gmail.com"
    password = "password2"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # delete todo
    delete '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:bad_request)

  end
end