class AddMovieIdToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :movie_id, :integer
  end
end
