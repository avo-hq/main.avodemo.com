# A chat user's thumbs up or down on one assistant reply, triaged by an admin in Avo.
#
# The table arrived after the rest of avo-ai's schema did, so it is its own migration: an app that
# installed avo-ai before this version runs `bin/rails generate avo:ai install` again and gets
# exactly this file. A fresh install gets the table from the create migration instead.
class CreateAvoAiFeedbacks < ActiveRecord::Migration[8.1]
  def change
    # An app that squashed its migrations declares this table in no file, so the installer cannot
    # tell and writes this migration to be safe.
    return if table_exists?(:avo_ai_feedbacks)

    create_table :avo_ai_feedbacks do |t|
      # Cascading, so a feedback lives and dies with its chat and reply. Prompt and response are
      # read from the message, never copied here.
      t.references :chat, null: false, foreign_key: {to_table: :avo_ai_chats, on_delete: :cascade}
      t.references :message, null: false, foreign_key: {to_table: :avo_ai_messages, on_delete: :cascade}
      t.references :user, polymorphic: true, null: false

      t.string :vote, null: false                     # up | down
      t.string :reason                                # set only on a down vote
      t.text :comment
      t.string :status, null: false, default: "open"  # open | in_progress | resolved
      t.text :admin_note
      # Set once the feedback has notified its reviewers, so a later change never notifies again.
      t.datetime :notified_at

      t.timestamps

      t.index :status
      t.index :vote
    end
  end
end
