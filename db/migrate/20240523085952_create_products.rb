class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :category
      t.integer :price_cents, default: 0, null: false
      t.string :price_currency, default: "USD", null: false

      t.timestamps
    end
  end
end
