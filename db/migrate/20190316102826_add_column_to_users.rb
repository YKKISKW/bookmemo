class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :raw_info, :text
  end
end
