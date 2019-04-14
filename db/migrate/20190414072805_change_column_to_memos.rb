class ChangeColumnToMemos < ActiveRecord::Migration[5.2]
  def change
    remove_reference :memos, :user, foreign_key: true
    remove_reference :memos, :book, foreign_key: true
    add_reference :memos, :book_shelf, foreign_key: true
  end
end
