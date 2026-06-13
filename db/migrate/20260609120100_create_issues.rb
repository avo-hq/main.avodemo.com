class CreateIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :issues do |t|
      t.integer :number
      t.string :title
      t.text :body
      t.string :status
      t.string :priority
      t.string :author

      t.timestamps
    end
  end
end
