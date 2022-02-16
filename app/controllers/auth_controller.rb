class AuthController < ApplicationController
  def login
    # Params checking
    if !params.has_key?(:email) || !params.has_key?(:password)
      render json: { status: "error", error: "Please fill the email and password fields"}, status: :bad_request
      return
    end

    # User search
    user_query = User.where(email: params[:email])
    if user_query.length == 0
      render json: { status: "error", error: "There is no user registered with this email"}, status: :bad_request
      return
    end

    # Password auth
    @user = user_query.first
    if !@user.authenticate(params[:password])
      render json: { status: "error", error: "The password is not valid"}, status: :bad_request
    else
      session[:user_id] = @user.id
      render json: { status: "success", message: "You have successfully logged in"}, status: :ok
    end
  end

  def logout
    if session[:user_id] == nil
      render json: { status: "error", error: "You are not currently logged in"}, status: :bad_request
    end
    session.delete(:user_id)
    render json: { status: "success", message: "You have successfully logged out"}, status: :ok
  end
end
