class UsersController < ApplicationController
  def index
  end

  def show
    @books = current_user.book_shelves
  end
end
