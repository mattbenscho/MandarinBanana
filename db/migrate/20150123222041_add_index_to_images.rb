class AddIndexToImages < ActiveRecord::Migration
  def change
    add_index :images, :mnemonic_id
    add_index :mnemonics, :pinyindefinition_id
    add_index :mnemonics, :gorodish_id
    add_index :featured_images, :hanzi_id
    add_index :featured_images, :created_at
    add_index :comments, :hanzi_id
    add_index :pinyindefinitions, :hanzi_id
  end
end
