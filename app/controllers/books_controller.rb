class BooksController < ApplicationController
protect_from_forgery except: :create
  def index
  end

  def new
  end

  def create
    book = Book.where(book_params)
    binding.pry
    if book.exists?
        BookShelf.create(user_id:current_user.id,book_id:book.ids[0])
    else
        Book.create(book_params).merge(user_ids:[current_user.id])
    end
  end

  private

  def book_params
    params.require(:book).permit(:title,:isbn13)
    # .merge(user_ids:[current_user.id])
  end
end
