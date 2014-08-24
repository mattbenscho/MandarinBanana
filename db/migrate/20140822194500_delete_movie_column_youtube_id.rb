class DeleteMovieColumnYoutubeId < ActiveRecord::Migration
  def change
    remove_column :movies, :youtube_id, :string
  end
end
