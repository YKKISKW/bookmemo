class MemosController < ApplicationController
  def index
    @memos = Memo.where(book_shelf_id:params[:book_shelf_id]).page(params[:page]).per(10).order("created_at DESC")
    @book_title = BookShelf.find(params[:book_shelf_id]).book.title
  end

  def show
  end

  def edit
  end

  def destroy
    memo = Memo.find(params[:id])
    memo.destroy if memo.book_shelf.user.id == current_user.id
    redirect_to book_shelf_memos_path(memo.book_shelf_id)
  end

end
