class ChangeDataIsbnToBooks < ActiveRecord::Migration[5.2]
  def up
    change_column :books, :isbn10, :integer
    change_column :books, :isbn13, :integer
  end
end
