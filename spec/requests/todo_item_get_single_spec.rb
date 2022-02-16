require "rails_helper"

describe 'Todo Item Get Single API', type: :request do

  it 'gets single todo item' do

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
    for i in 1..5
      todo_text = 'item_content_'+i.to_s
      post '/todos/'+todo_id.to_s+'/items?text='+todo_text
      expect(response).to have_http_status(:created)
    end

    # get todo items
    get '/todos/'+todo_id.to_s
    expect(response).to have_http_status(:ok)
    todo_items = JSON.parse(response.body)["items"]

    # validate item field
    for item in todo_items
      get '/todos/'+item["id"].to_s+'/items'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["item"]["text"]).to eq("item_content_"+item["id"].to_s)
    end

  end

  it 'tries to get single todo item that does not exist' do

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

    get '/todos/9999999/items'
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to get single todo item that does not belong to user' do

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

    # get todo item
    get '/todos/'+todo_item_id.to_s
    expect(response).to have_http_status(:bad_request)

  end


  it 'tries to get single todo item whithout loging in' do

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

    # delete todo
    get '/todos/'+todo_item_id.to_s
    expect(response).to have_http_status(:bad_request)

  end
end