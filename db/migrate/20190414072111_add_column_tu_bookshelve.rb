class AddColumnTuBookshelve < ActiveRecord::Migration[5.2]
  def change
    add_column :book_shelves, :status, :integer,null: false
  end
end
