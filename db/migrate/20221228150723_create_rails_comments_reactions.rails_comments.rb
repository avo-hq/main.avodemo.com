# This migration comes from rails_comments (originally 20221222134304)
class CreateRailsCommentsReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_comments_reactions do |t|
      t.string :emoji, null: false
      t.string :author_type, null: false
      t.string :author_id, null: false
      t.integer :comment_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
