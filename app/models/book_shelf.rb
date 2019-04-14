class BookShelf < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :memos,dependent: :destroy

  validates :book_id, uniqueness: { scope: :user_id,
    message: "その本は既に登録済みです" }
end
