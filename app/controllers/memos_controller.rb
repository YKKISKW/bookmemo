class MemosController < ApplicationController
  def index
    @memos = current_user.memos.where(book_id:params[:book_id])
  end

  def show
  end

  def edit
  end

  def destroy
  end

end
