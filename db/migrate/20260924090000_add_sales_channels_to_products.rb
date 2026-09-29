# Backs the `sales_channels` multiple select on the Product resource -- the
# demo's one example of `as: :select, multiple: true`. A Postgres string array
# so the field can store several picks on one column; existing rows start empty.
class AddSalesChannelsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :sales_channels, :string, array: true, default: [], null: false
  end
end
