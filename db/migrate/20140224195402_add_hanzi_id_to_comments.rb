class AddHanziIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :hanzi_id, :integer
  end
end
