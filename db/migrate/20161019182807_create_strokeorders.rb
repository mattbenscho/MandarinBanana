class CreateStrokeorders < ActiveRecord::Migration
  def change
    create_table :strokeorders do |t|
      t.integer :hanzi_id
      t.integer :user_id
      t.text :strokes

      t.timestamps 
    end
  end
end
