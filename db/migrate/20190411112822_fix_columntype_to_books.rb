class FixColumntypeToBooks < ActiveRecord::Migration[5.2]
  def up
    change_column :books, :isbn13, :string
    remove_column :books, :isbn10
  end

  def down
    change_column :books, :isbn13, :bigint
    add_column :books, :isbn10,:bigint
  end
end
