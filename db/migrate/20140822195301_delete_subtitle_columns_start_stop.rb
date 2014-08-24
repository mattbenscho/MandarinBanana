class DeleteSubtitleColumnsStartStop < ActiveRecord::Migration
  def change
    remove_column :subtitles, :start
    remove_column :subtitles, :stop
    add_column :subtitles, :filename, :string
  end
end
