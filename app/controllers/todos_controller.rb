class TodosController < ApplicationController

  # GET /todos
  def index
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    @todos = Todo.where(user_id: session[:user_id])
    render json:{status: "success", todos: @todos}, status: :ok
  end

  def create
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # Params checking
    if !params.has_key?(:name) || !params.has_key?(:description) ||
      params[:name] == "" || params[:description] == "" ||
      params[:name] == nil || params[:description] == nil
    then
      render json: { status: "error", error: "Please fill the name and description fields"}, status: :bad_request
      return
    end

    # Todo creation
    @todo = Todo.new(name:params[:name], description:params[:description], user_id:session[:user_id])
    if @todo.save
      render json: { status: "success", message: "Your todo was successfully created"}, status: :created
    else
      render json: { status: "error", error: @todo.errors}, status: :unprocessable_entity
    end
  end

  # GET /todos/1
  def show
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo
    @todo = find_todo
    if @todo == nil
      render json: { status: "error", error: "No todo found with this id"}, status: :bad_request
      return
    end

    if @todo.user_id != session[:user_id]
      render json: { status: "error", error: "This todo doesn't belong to you"}, status: :bad_request
      return
    end

    render json:{
      status: "success",
      todo: @todo,
      items: TodoItem.where(todo_id: @todo.id)
    }, status: :ok
  end

  # PUT /todos/1
  def update
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo
    @todo = find_todo
    if @todo == nil
      render json: { status: "error", error: "No todo found with this id"}, status: :bad_request
      return
    end

    # check if user owns todo
    if @todo.user_id != session[:user_id]
      render json: { status: "error", error: "This todo doesn't belong to you"}, status: :bad_request
      return
    end

    # update fields
    if params.has_key?(:name)
      @todo.name = params[:name]
    end
    if params.has_key?(:description)
      @todo.description = params[:description]
    end


    # todo save again
    if @todo.save
      render json: { status: "success", message: "Your todo was successfully updated"}, status: :ok
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def delete
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo
    @todo = find_todo
    if @todo == nil
      render json: { status: "error", error: "No todo found with this id"}, status: :bad_request
      return
    end

    # check if user owns todo
    if @todo.user_id != session[:user_id]
      render json: { status: "error", error: "This todo doesn't belong to you"}, status: :bad_request
      return
    end

    for @item in TodoItem.where(todo_id:@todo.id)
      if !@item.destroy
        render json: { status: "error", error: @item.errors}, status: :bad_request
        return
      end
    end

    # todo delete
    if @todo.destroy
      render json: { status: "success", message: "Your todo was successfully deleted"}, status: :ok
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  private
    def find_todo
      todo_query = Todo.where(id: params[:id])
      if todo_query.length == 0
        return nil
      end
      todo_query.first
    end
end
