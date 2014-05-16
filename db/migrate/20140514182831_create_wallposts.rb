class CreateWallposts < ActiveRecord::Migration
  def change
    create_table :wallposts do |t|
      t.text :content
      t.integer :user_id
      t.integer :parent_id

      t.timestamps
    end
    add_index :wallposts, [:user_id, :created_at]
    add_index :wallposts, [:parent_id, :created_at]
  end
end
