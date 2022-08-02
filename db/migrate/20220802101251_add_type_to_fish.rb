class AddTypeToFish < ActiveRecord::Migration[7.0]
  def change
    add_column :fish, :type, :string
  end
end
