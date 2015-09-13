class AddCreatedAtIndexToMnemonics < ActiveRecord::Migration
  def change
    add_index :mnemonics, :created_at
  end
end
