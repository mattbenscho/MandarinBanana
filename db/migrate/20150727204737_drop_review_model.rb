class DropReviewModel < ActiveRecord::Migration
  def up
    drop_table :reviews
  end

  def down
    create_table :reviews do |t|
      t.integer :hanzi_id
      t.integer :user_id
      t.datetime :due
      t.integer :failed

      t.timestamps
    end

    add_index :reviews, :hanzi_id
    add_index :reviews, :user_id
    add_index :reviews, [:hanzi_id, :user_id], unique: true
    add_index :reviews, :due
    add_index :reviews, :failed
  end
end
