class CreatePullRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :pull_requests do |t|
      t.integer :number
      t.string :title
      t.text :body
      t.string :status
      t.string :branch
      t.boolean :draft, default: false
      t.string :author

      t.timestamps
    end
  end
end
