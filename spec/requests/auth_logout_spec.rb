require "rails_helper"

describe 'Auth Logout API', type: :request do
  it 'tries to logout' do
    # sign in
    random_number = rand(1..1000000).to_s
    email = "user" + random_number + "@gmail.com"
    password = "password" + random_number
    post '/signup?email=' + email + '&password=' + password

    session_id_before = session[:user_id]

    # then try logout
    get '/auth/logout'

    session_id_after = session[:user_id]

    expect(session_id_after).not_to eq(session_id_before)
    expect(session_id_after).to eq(nil)
  end
end