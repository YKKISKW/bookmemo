class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :isbn13
      t.integer :isbn10
      t.text :text,null:false
      t.timestamps
    end

    add_index :books, :isbn10, unique: true
    add_index :books, :isbn13, unique: true
  end
end
