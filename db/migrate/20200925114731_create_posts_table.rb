class CreatePostsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.text :body
      t.boolean :is_featured
      t.timestamp :published_at
      t.references :user, foreign_key: true
      t.text :custom_css

      t.timestamps null: false
    end
  end
end
