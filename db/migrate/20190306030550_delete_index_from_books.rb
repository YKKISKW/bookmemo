class DeleteIndexFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_index :books, :isbn13
    remove_index :books, :isbn10
  end
end
