# Reusable prompt snippets an admin writes in Avo and drops into a chat by typing `/`.
#
# The table arrived after the rest of avo-ai's schema did, so it is its own migration: an app that
# installed avo-ai before this version runs `bin/rails generate avo:ai install` again and gets
# exactly this file. A fresh install gets the table from the create migration instead, and never
# sees this one.
class CreateAvoAiSkills < ActiveRecord::Migration[8.1]
  def change
    # An app that squashed its migrations says nothing about this table in any file, so the
    # installer cannot tell whether it already has it and writes this migration to be safe.
    # Asking the database is what settles it — and makes the migration a no-op rather than a
    # "relation already exists" halfway through a deploy.
    return if table_exists?(:avo_ai_skills)

    create_table :avo_ai_skills do |t|
      t.string :title, null: false
      # Optional. One line for the person choosing in the `/` menu; never sent to the model.
      t.string :description
      t.text :body, null: false

      t.timestamps

      t.index :title, unique: true
    end
  end
end
