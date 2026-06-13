class CreateDbConfig < ActiveRecord::Migration[8.0]
  def change
    create_table :db_config_records do |t|
      t.string :key, null: false
      t.string :value
      t.string :value_type, null: false, default: "String"
      t.boolean :eager_load, null: false, default: false

      t.timestamps null: false
    end

    add_index :db_config_records, :key, unique: true
    add_index :db_config_records, :eager_load
  end
end
