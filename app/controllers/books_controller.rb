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

end
