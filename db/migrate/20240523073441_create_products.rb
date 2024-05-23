class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :category
      t.integer :price_cents
      t.string :price_currency

      t.timestamps
    end
  end
end
