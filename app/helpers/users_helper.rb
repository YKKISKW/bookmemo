module UsersHelper
    require 'google/apis/books_v1'
    def search_with_google_api(q)
    service = Google::Apis::BooksV1::BooksService.new
    response = service.list_volumes(q)
    response.items.select do |item|
      identifier_types = item.volume_info&.industry_identifiers&.map(&:type)
      identifier_types&.include?('ISBN_10') || identifier_types&.include?('ISBN_13')
    end.map(&:as_json)
  end
end
