# What a message row knows beyond its content, keyed by concern. An error row keeps the failure it
# reports under "error": its kind, the exception's class, and whether retrying can help
# (Avo::Ai::RunError, read through Message#error_details). One JSON column rather than one per
# concern, so the next thing a row has to remember costs a host no migration.
#
# The column arrived after the rest of avo-ai's schema, so it is its own migration: an app that
# installed avo-ai before this version runs `bin/rails generate avo:ai install` again and gets this
# file. A fresh install gets the column from the create migration instead.
class AddMetaToAvoAiMessages < ActiveRecord::Migration[8.1]
  def change
    # An app that squashed its migrations declares this column in no file, so the installer cannot
    # tell and writes this migration to be safe.
    return if column_exists?(:avo_ai_messages, :meta)

    add_column :avo_ai_messages, :meta, :json
  end
end
