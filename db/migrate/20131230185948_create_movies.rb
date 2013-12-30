class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :youtube_id

      t.timestamps
    end
  end
end
