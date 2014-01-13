class CreateHanzis < ActiveRecord::Migration
  def change
    create_table :hanzis do |t|
      t.string :character
      t.string :components

      t.timestamps
    end

    add_index :hanzis, :character
  end
end
