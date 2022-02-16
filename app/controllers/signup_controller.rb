class SignupController < ApplicationController
  # POST /signup
  def index

    # Params checking
    if !params.has_key?(:email) || !params.has_key?(:password) ||
      params[:email] == "" || params[:password] == "" ||
      params[:email] == nil || params[:password] == nil
    then
      render json: { status: "error", error: "Please fill the email and password fields"}, status: :bad_request
      return
    end

    # User creation
    @user = User.new(email:params[:email], password:params[:password])
    if @user.save
      session[:user_id] = @user.id
      render json: { status: "success", message: "Your account was successfully created"}, status: :created
    else
      render json: { status: "error", error: @user.errors}, status: :unprocessable_entity
    end

  end
end
