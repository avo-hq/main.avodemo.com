class CreateAvoNotificationsNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :avo_notifications_notifications do |t|
      t.string :title, null: false
      t.text :body
      t.integer :level, null: false, default: 0
      t.string :notification_type
      t.string :url
      t.references :recipient, polymorphic: true, null: false, index: true
      t.references :sender, polymorphic: true, null: true, index: true
      t.json :buttons
      t.datetime :read_at, index: true
      t.datetime :saved_at, index: true
      t.datetime :marked_as_done_at, index: true
      t.datetime :expires_at, index: true

      t.timestamps
    end

    add_index :avo_notifications_notifications, :level
    add_index :avo_notifications_notifications, :created_at
  end
end
