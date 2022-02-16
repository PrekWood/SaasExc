require "rails_helper"

describe 'Todo Get Single API', type: :request do

  it 'gets single todo' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
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
    todos_json = JSON.parse(response.body)["todos"]

    # get todo
    get '/todos/'+todos_json[0]["id"].to_s
    expect(response).to have_http_status(:ok)
    todo_json = JSON.parse(response.body)["todo"]


    expect(todo_json["name"]).to eq(todos_json[0]["name"])
    expect(todo_json["description"]).to eq(todos_json[0]["description"])
  end

  it "tries to reach other user's todo" do

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
    user1_todos = JSON.parse(response.body)["todos"]

    # then try logout
    get '/auth/logout'

    # sign in as other user
    email = "user2@gmail.com"
    password = "password2"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # try get first user's todo
    get '/todos/'+user1_todos[0]["id"].to_s
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to get a todo without login' do
    get '/todos/1'
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to get a todo that does not exist' do
    # sign in
    email = "user1@gmail.com"
    password = "password1"
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    get '/todos/9999999999999999'
    expect(response).to have_http_status(:bad_request)
  end

end