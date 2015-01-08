class AddPinyindefinitionIdToFeaturedImages < ActiveRecord::Migration
  def change
    add_column :featured_images, :pinyindefinition_id, :integer
  end
end
