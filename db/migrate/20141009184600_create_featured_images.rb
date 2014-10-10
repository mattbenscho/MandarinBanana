class CreateFeaturedImages < ActiveRecord::Migration
  def change
    create_table :featured_images do |t|
      t.text :data
      t.text :mnemonic_aide
      t.integer :hanzi_id
      t.text :commentary

      t.timestamps
    end
  end
end
