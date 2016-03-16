class RemoveVocabularyFromSubtitles < ActiveRecord::Migration
  def change
    remove_column :subtitles, :vocabulary, :text
  end
end
