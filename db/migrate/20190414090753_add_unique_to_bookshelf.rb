class AddUniqueToBookshelf < ActiveRecord::Migration[5.2]
  def change
    add_index :book_shelves, [:user_id, :book_id], :name => 'unique_user_book', :unique => true
  end
end
