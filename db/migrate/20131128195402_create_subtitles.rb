class CreateSubtitles < ActiveRecord::Migration
  def change
    create_table :subtitles do |t|
      t.text :sentence
      t.integer :start
      t.integer :stop

      t.timestamps
    end
    add_index :subtitles, :start
  end
end
