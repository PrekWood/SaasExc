require "rails_helper"

describe 'Todo Update API', type: :request do

  it 'updates todo' do

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
    todo_before_update = JSON.parse(response.body)["todos"][0]
    todo_id = todo_before_update["id"]

    # update
    put '/todos/'+todo_id.to_s+'?name=new_name&description=new_description'
    expect(response).to have_http_status(:ok)

    # get updated todo
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_after_update = JSON.parse(response.body)["todo"]

    expect(todo_after_update["name"]).not_to eq(todo_before_update["name"])
    expect(todo_after_update["description"]).not_to eq(todo_before_update["description"])
    expect(todo_after_update["name"]).to eq("new_name")
    expect(todo_after_update["description"]).to eq("new_description")

  end

  it 'tries to update todo without login' do
    # update
    put '/todos/1?name=new_name&description=new_description'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to update todo that does not exist' do
    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # update
    put '/todos/99999999999999999?name=new_name&description=new_description'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to update todo what does not belog to user' do

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

    # update
    put '/todos/'+todo_id.to_s+'?name=new_name&description=new_description'
    expect(response).to have_http_status(:bad_request)

  end

end