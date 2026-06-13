# This migration comes from avo_collaboration (originally 20241127094621)
class CreateAvoCollaborationReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :avo_collaboration_reactions do |t|
      t.string :emoji
      t.string :body

      t.timestamps
    end
  end
end
