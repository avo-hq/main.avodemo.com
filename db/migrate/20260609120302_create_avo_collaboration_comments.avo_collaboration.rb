# This migration comes from avo_collaboration (originally 20241005223223)
class CreateAvoCollaborationComments < ActiveRecord::Migration[7.2]
  def change
    create_table :avo_collaboration_comments do |t|
      t.text :body

      t.timestamps
    end
  end
end
