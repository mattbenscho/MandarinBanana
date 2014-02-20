class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.integer :expression_id
      t.integer :subtitle_id

      t.timestamps
    end

    add_index :examples, :expression_id
    add_index :examples, :subtitle_id
    add_index :examples, [:expression_id, :subtitle_id], unique: true
  end
end
