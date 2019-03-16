class BooksController < ApplicationController
  require 'net/http'
  require 'uri'
  require "addressable/uri"
  require 'json'

  # protect_from_forgery except: :create

  def index
  end


  def new(retry_count = 10)
    raise ArgumentError, 'too many HTTP redirects' if retry_count == 0

    uri = Addressable::URI.parse("https://www.googleapis.com/books/v1/volumes?q=#{params[:form_word]}")
    # results = []
    begin
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.open_timeout = 5
        http.read_timeout = 10
        http.get(uri.request_uri)
      end

      case response
        when Net::HTTPSuccess
          json = JSON.parse(response.body)
          if json['results_returned'] == 0
            nil
          else
            @results = json["items"]
          end

        when Net::HTTPRedirection
          location = response['location']
          Rails.logger.error(warn "redirected to #{location}")
          search_area(form_word , retry_count - 1)
        else
          Rails.logger.error([uri.to_s, response.value].join(" : "))
      end

    rescue => e
      Rails.logger.error(e.message)
      raise e
    end
    # @results = results
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
