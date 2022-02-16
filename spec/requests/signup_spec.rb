require "rails_helper"

describe 'Signup API', type: :request do
  it 'Signs user up' do
    random_number = rand(1..1000000).to_s

    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number

    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:created)
  end

  it 'checks if the user count changed' do
    user_count_before = User.count

    # make call
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    user_count_after = User.count
    expect(user_count_after).equal?(user_count_before + 1)
  end

  it 'tries to sign user with empty email' do
    random_number = rand(1..1000000).to_s

    email = ""
    password = "password" + random_number

    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to sign user with empty password' do
    random_number = rand(1..1000000).to_s

    email = "user" + random_number + "@gmail.com"
    password = ""

    post '/signup?email=' + email + '&password=' + password
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to sign user without email' do
    random_number = rand(1..1000000).to_s

    password = "password" + random_number

    post '/signup?password=' + password
    expect(response).to have_http_status(:bad_request)
  end

  it 'tries to sign user without password' do
    random_number = rand(1..1000000).to_s

    email = "user" + random_number + "@gmail.com"

    post '/signup?email=' + email
    expect(response).to have_http_status(:bad_request)
  end


end