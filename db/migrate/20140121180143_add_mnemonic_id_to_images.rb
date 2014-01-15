class AddMnemonicIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :mnemonic_id, :integer
  end
end
