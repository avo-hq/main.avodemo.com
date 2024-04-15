class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :population
      t.boolean :is_capital
      t.json :features
      t.json :metadata
      t.string :image_url
      t.text :tiny_description
      t.float :longitude
      t.float :latitude
      t.json :city_center_area

      t.timestamps
    end
  end
end
