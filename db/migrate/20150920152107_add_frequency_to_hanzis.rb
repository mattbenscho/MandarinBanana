class AddFrequencyToHanzis < ActiveRecord::Migration
  def change
    add_column :hanzis, :frequency, :integer, default: 0
    add_index :hanzis, :frequency
  end
end
