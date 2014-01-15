class CreateGorodishes < ActiveRecord::Migration
  def change
    create_table :gorodishes do |t|
      t.string :element

      t.timestamps
    end
    add_index :gorodishes, :element, unique: true
  end
end
