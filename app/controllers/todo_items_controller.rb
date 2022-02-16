class TodoItemsController < ApplicationController
  def show
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo
    @item = find_todo_item
    if @item == nil
      render json: { status: "error", error: "No todo item found with this id"}, status: :bad_request
      return
    end

    render json: { status: "success", item: @item}
  end

  def delete
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo item
    @item = find_todo_item
    if @item == nil
      render json: { status: "error", error: "No todo item found with this id"}, status: :bad_request
      return
    end

    # check if user owns todo
    @todo = Todo.find(@item.todo_id)
    if @todo.user_id != session[:user_id]
      render json: { status: "error", error: "This todo doesn't belong to you"}, status: :bad_request
      return
    end

    # item delete
    if @item.destroy
      render json: { status: "success", message: "Your todo item was successfully deleted"}, status: :ok
    else
      render json: { status: "error", error: @item.errors }, status: :unprocessable_entity
    end

  end

  def update
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # search for todo item
    @item = find_todo_item
    if @item == nil
      render json: { status: "error", error: "No todo item found with this id"}, status: :bad_request
      return
    end

    # check if user owns todo
    @todo = Todo.find(@item.todo_id)
    if @todo.user_id != session[:user_id]
      render json: { status: "error", error: "This todo doesn't belong to you"}, status: :bad_request
      return
    end

    # Params checking
    if !params.has_key?(:text)
      render json: { status: "error", error: "Please fill the text field"}, status: :bad_request
      return
    end

    # item update
    @item.text = params[:text]
    if @item.save
      render json: { status: "success", message: "Your todo item was successfully updated"}, status: :ok
    else
      render json: { status: "error", error: @item.errors}, status: :unprocessable_entity
    end

  end

  def create
    # User check
    if session[:user_id] == nil
      render json: { status: "error", error: "Please login or sign up" }, status: :bad_request
      return
    end

    # Params checking
    if !params.has_key?(:text)
      render json: { status: "error", error: "Please fill the text and id_task fields"}, status: :bad_request
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

    # Todo creation
    @item = TodoItem.new(text:params[:text], todo_id:@todo.id)
    if @item.save
      render json: { status: "success", message: "Your todo item was successfully created"}, status: :created
    else
      render json: { status: "error", error: @todo.errors}, status: :unprocessable_entity
    end
  end

  private
    def find_todo_item
      item_query = TodoItem.where(id: params[:id])
      if item_query.length == 0
        return nil
      end
      item_query.first
    end
    def find_todo
      todo_query = Todo.where(id: params[:id])
      if todo_query.length == 0
        return nil
      end
      todo_query.first
    end
end
