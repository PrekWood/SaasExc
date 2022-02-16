require "rails_helper"

describe 'Auth Login API', type: :request do

  it 'tries to login' do
    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?email=' + email + '&password=' + password
    expect(response).to have_http_status(:ok)
  end

  it 'checks if the session is set' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?email=' + email + '&password=' + password

    session_id_before = nil
    session_id_after = session[:user_id]

    expect(session_id_after).not_to eq(session_id_before)
  end

  it 'tries to log in with empty email' do

    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?email=&password=' + password
    expect(response).to have_http_status(:bad_request)

  end

  it 'tries to log in with empty password' do
    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?email='+email+'&password='
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to log in without email' do
    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?password=' + password
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to log in without password' do
    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    #then try login
    post '/auth/login?email='+email
    expect(response).to have_http_status(:bad_request)
  end

end