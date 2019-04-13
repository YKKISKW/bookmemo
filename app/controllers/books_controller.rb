class BooksController < ApplicationController
  before_action :move_to_line,except: [:index,:new]

  def index
  end


  def new(retry_count = 10)
    @results = Book.search_with_google_api(params[:form_word])
    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
  end

  def create
    book = Book.where(book_params)
    if book.exists?
        BookShelf.create(user_id:current_user.id,book_id:book.ids[0])
        redirect_to user_path(current_user.id)
    else
        Book.create(book_params.merge(user_ids:[current_user.id]))
        redirect_to user_path(current_user.id)
    end
  end

  def destroy
    book = current_user.book_shelves.where(book_id:params[:id])
    book[0].destroy
    redirect_to user_path(current_user.id)
  end

  private

  def book_params
    params.require(:book).permit(:title,:isbn13)
    # .merge(user_ids:[current_user.id])
  end

  def move_to_line
      redirect_to user_line_omniauth_authorize_path unless user_signed_in?
  end
end
