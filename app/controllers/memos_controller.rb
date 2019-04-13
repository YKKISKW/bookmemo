class MemosController < ApplicationController
  def index
    @memos = current_user.memos.where(book_id:params[:book_id]).page(params[:page]).per(10).order("created_at DESC")
    @book_title = Book.find(params[:book_id]).title
  end

  def show
  end

  def edit
  end

  def destroy
    memo = Memo.find(params[:id])
    memo.destroy if memo.user_id == current_user.id
    redirect_to book_memos_path(memo.book_id)
  end

end
