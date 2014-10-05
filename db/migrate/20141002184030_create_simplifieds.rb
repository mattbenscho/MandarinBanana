class CreateSimplifieds < ActiveRecord::Migration
  def change
    create_table :simplifieds do |t|
      t.integer :trad_id
      t.integer :simp_id

      t.timestamps
    end
    add_index :simplifieds, :trad_id
    add_index :simplifieds, :simp_id
    add_index :simplifieds, [:trad_id, :simp_id], unique: true
  end
end
