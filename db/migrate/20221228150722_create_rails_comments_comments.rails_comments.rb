# This migration comes from rails_comments (originally 20221222103402)
class CreateRailsCommentsComments < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_comments_comments do |t|
      t.text :body
      # The resource on which the comment has been added
      t.string :commentable_type, null: false, foreign_key: false
      t.string :commentable_id, null: false, foreign_key: false
      # The user who made the comment
      t.string :author_type, null: true, foreign_key: false
      t.string :author_id, null: true, foreign_key: false
      # The parent comment if it's nested
      t.string :parent_id, null: true, foreign_key: false

      t.timestamps
    end
  end
end
