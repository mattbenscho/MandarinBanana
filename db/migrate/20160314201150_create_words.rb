class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :characters
      t.text :translation
      t.integer :HSK

      t.timestamps null: false
    end
    add_index :words, :HSK
    add_index :words, :characters, :unique => true
  end
end
