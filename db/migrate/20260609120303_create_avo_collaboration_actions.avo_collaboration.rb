# This migration comes from avo_collaboration (originally 20241005223347)
class CreateAvoCollaborationActions < ActiveRecord::Migration[7.2]
  def change
    create_table :avo_collaboration_actions do |t|
      t.text :body, null: true
      t.string :property
      t.string :old_value
      t.string :new_value
      t.string :batch_id, null: true

      t.timestamps
    end
  end
end
