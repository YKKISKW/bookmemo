class ChangeDatatypeIsbnToBooks < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :isbn10, :bigint
    change_column :books, :isbn13, :bigint
  end
end
