class RenameTextColumnToBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :text, :title
  end
end
