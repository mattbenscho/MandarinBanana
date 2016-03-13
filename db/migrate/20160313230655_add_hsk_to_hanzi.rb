class AddHskToHanzi < ActiveRecord::Migration
  def change
    add_column :hanzis, :HSK, :integer
  end
end
