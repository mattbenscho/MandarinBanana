class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :subtitle_id

      t.timestamps
    end
    add_index :comments, [:subtitle_id, :created_at]
  end
end
