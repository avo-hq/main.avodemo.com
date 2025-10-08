class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :body
      t.datetime :event_time

      t.timestamps
    end
  end
end
