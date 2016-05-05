class AddSimplifiedTraditionalPinyinToWords < ActiveRecord::Migration
  def change
    remove_index :words, :characters
    rename_column :words, :characters, :simplified
    add_column :words, :traditional, :string
    add_column :words, :pinyin, :string
    add_column :words, :frequency, :string
    add_index :words, :simplified
    add_index :words, :traditional
    add_index :words, :frequency
  end
end
