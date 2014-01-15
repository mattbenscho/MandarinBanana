class CreateMnemonics < ActiveRecord::Migration
  def change
    create_table :mnemonics do |t|
      t.text :aide
      t.integer :user_id
      t.integer :pinyindefinition_id
      t.integer :gorodish_id

      t.timestamps
    end
  end
end
