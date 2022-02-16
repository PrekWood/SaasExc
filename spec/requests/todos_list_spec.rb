require "rails_helper"

describe 'Todo List API', type: :request do

  it 'gets todo list' do
    # Sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    todos_count_before = Todo.count

    # Create random number of todos
    todos_number = rand(1..100)
    for todos_index in 1..todos_number do
      todo_name = 'todo_'+todos_index.to_s
      todo_description = 'todo_desc_'+todos_index.to_s
      post '/todos?name=' + todo_name + '&description=' + todo_description
      expect(response).to have_http_status(:created)
    end

    todos_count_after = Todo.count

    # Make sure they are created correctly
    expect(todos_count_after).not_to eq(todos_count_before)
    expect(todos_count_before).to eq(0)
    expect(todos_count_after).to eq(todos_number)

    # Get list
    get '/todos'
    expect(response).to have_http_status(:ok)

    # Json parse the response
    response_json = JSON.parse(response.body)["todos"]
    expect(response_json.length).to eq(todos_number)
  end

  it 'checks that a user can not reach todos of another' do
    # Sign in user 1
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # Create random number of todos for user 1
    todos_number_1 = rand(1..100)
    for todos_index in 1..todos_number_1 do
      todo_name = 'todo_1_'+todos_index.to_s
      todo_description = 'todo_desc_1_'+todos_index.to_s
      post '/todos?name=' + todo_name + '&description=' + todo_description
      expect(response).to have_http_status(:created)
    end

    # Get list for user 1
    get '/todos'
    expect(response).to have_http_status(:ok)
    todos_1 = JSON.parse(response.body)["todos"]
    expect(todos_1.length).to eq(todos_number_1)

    # Logout
    get '/auth/logout'
    expect(response).to have_http_status(:ok)


    # Sign in user 2
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)

    # Create random number of todos for user 2
    todos_number_2 = rand(1..100)
    for todos_index in 1..todos_number_2 do
      todo_name = 'todo_2_'+todos_index.to_s
      todo_description = 'todo_desc_2_'+todos_index.to_s
      post '/todos?name=' + todo_name + '&description=' + todo_description
      expect(response).to have_http_status(:created)
    end

    # Get todos list for user 2
    get '/todos'
    expect(response).to have_http_status(:ok)
    todos_2 = JSON.parse(response.body)["todos"]
    expect(todos_2.length).to eq(todos_number_2)

    # Check that there are no same todos
    for todos_1_index in 0..todos_1.length-1 do
      for todos_2_index in 0..todos_2.length-1 do
        todos_1_id = todos_1[todos_1_index]["id"]
        todos_2_id = todos_2[todos_2_index]["id"]
        expect(todos_1_id).not_to eq(todos_2_id)
      end
    end
  end

  it 'gets todo list without login' do
    # Get list
    get '/todos'
    expect(response).to have_http_status(:bad_request)
  end
end