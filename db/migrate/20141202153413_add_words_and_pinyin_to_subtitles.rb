class AddWordsAndPinyinToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :words, :text
    add_column :subtitles, :pinyin, :text
  end
end
