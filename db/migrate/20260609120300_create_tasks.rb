class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.boolean :completed, default: false
      t.date :due_on
      t.string :assignee

      t.timestamps
    end
  end
end
