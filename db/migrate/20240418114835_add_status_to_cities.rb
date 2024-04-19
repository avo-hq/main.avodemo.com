class AddStatusToCities < ActiveRecord::Migration[7.1]
  def change
    add_column :cities, :status, :string
  end
end
