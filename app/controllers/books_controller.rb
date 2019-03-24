class BooksController < ApplicationController

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
    else
        Book.create(book_params.merge(user_ids:[current_user.id]))
    end
  end

  private

  def book_params
    params.require(:book).permit(:title,:isbn13)
    # .merge(user_ids:[current_user.id])
  end
end
