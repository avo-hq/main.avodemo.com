class CreateAvoKanban < ActiveRecord::Migration[7.2]
  def change
    create_table :avo_kanban_boards do |t|
      t.string :name
      t.integer :columns_count, default: 0
      t.integer :items_count, default: 0
      t.jsonb :settings

      t.timestamps
    end

    create_table :avo_kanban_columns do |t|
      t.string :name
      t.references :board, null: true
      t.integer :position
      t.integer :items_count, default: 0
      t.jsonb :settings

      t.timestamps
    end

    create_table :avo_kanban_items do |t|
      t.references :board, null: true
      t.references :column, null: true
      t.integer :position
      t.references :record, polymorphic: true, null: true

      t.timestamps
    end
  end
end
