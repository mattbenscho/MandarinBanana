class AddHskToSubtitles < ActiveRecord::Migration
  def change
    add_column :subtitles, :HSK, :integer
  end
end
