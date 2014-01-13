class CreatePinyindefinitions < ActiveRecord::Migration
  def change
    create_table :pinyindefinitions do |t|
      t.string :pinyin
      t.text :definition
      t.integer :hanzi_id
      t.string :gbeginning
      t.string :gending

      t.timestamps
    end
    add_index :pinyindefinitions, [:hanzi_id, :pinyin]
    add_index :pinyindefinitions, [:hanzi_id, :pinyin, :definition], unique: true
  end
end
