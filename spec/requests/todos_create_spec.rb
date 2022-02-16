require "rails_helper"

describe 'Todo Create API', type: :request do

  it 'creates random number of todos' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    todos_count_before = Todo.count

    # create random number of todos
    todos_number = rand(1..100)
    for todos_index in 1..todos_number do
      todo_name = 'todo_'+todos_index.to_s
      todo_description = 'todo_desc_'+todos_index.to_s
      post '/todos?name=' + todo_name + '&description=' + todo_description
      expect(response).to have_http_status(:created)
    end

    todos_count_after = Todo.count

    expect(todos_count_after).not_to eq(todos_count_before)
    expect(todos_count_before).to eq(0)
    expect(todos_count_after).to eq(todos_number)

  end

  it 'tries to create todos when not loged in' do

    # create todo
    todo_name = 'todo_1'
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:bad_request)

  end


  it 'tries to create todo with empty name' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create todo
    todo_name = ''
    todo_description = 'todo_desc_1'
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to create todo with empty description' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create todo
    todo_name = 'todo_1'
    todo_description = ''
    post '/todos?name=' + todo_name + '&description=' + todo_description
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to create todo without name' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create todo
    todo_description = 'description_1'
    post '/todos?description=' + todo_description
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to create todo without description' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # create todo
    todo_name = 'todo_1'
    post '/todos?name=' + todo_name
    expect(response).to have_http_status(:bad_request)

  end

end