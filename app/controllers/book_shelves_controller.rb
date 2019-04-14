class BookShelvesController < ApplicationController
    before_action :move_to_line,only: [:create,:destroy]

  def create
    book = Book.where(book_params)
    if book.exists?
      book_shelf = BookShelf.new(user_id:current_user.id,book_id:book.ids[0])
      if book_shelf.save
        redirect_to user_path(current_user.id)
      end
    else
       new_book =  Book.new(book_params.merge(user_ids:[current_user.id]))
       new_book.save
       redirect_to user_path(current_user.id)
    end
  end

  def destroy
    book = BookShelf.find(params[:id])
    book.destroy
    redirect_to user_path(current_user.id)
  end

  private

  def book_params
    params.require(:book).permit(:title,:isbn13)
  end


  def move_to_line
      redirect_to user_line_omniauth_authorize_path unless user_signed_in?
  end
end
