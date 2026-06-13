# This migration comes from avo_collaboration (originally 20241005223034)
class CreateAvoCollaborationEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :avo_collaboration_entries do |t|
      t.string :entryable_type
      t.integer :entryable_id
      t.string :target_type
      t.integer :target_id
      t.string :author_type
      t.integer :author_id

      t.timestamps
    end
  end
end
