class AddEnglishAndChinglishToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :english, :text, default: ""
    add_column :subtitles, :chinglish, :text, default: ""
  end
end
