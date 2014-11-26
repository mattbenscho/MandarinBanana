class AddVocabularyToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :vocabulary, :text
  end
end
