class CangeDefaultToBookshelves < ActiveRecord::Migration[5.2]
  def up
    change_column :book_shelves, :status, :integer, null: false, default: 0
  end
end
