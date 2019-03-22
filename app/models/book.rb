class Book < ApplicationRecord
  has_many :book_shelves
  has_many :users, through: :book_shelves

end
