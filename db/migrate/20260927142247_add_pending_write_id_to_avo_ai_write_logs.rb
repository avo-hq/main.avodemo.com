# The confirmed batch a write-log row was part of. update_records applies one confirmation to many
# records and logs each one; this column ties them back together, so the history tool lists the
# batch as one entry and can undo it with one confirmation instead of one per record.
#
# An app that installed avo-ai before this version runs `bin/rails generate avo:ai install` again
# and gets this file. A fresh install gets the column from the create migration instead.
class AddPendingWriteIdToAvoAiWriteLogs < ActiveRecord::Migration[8.1]
  def change
    # An app that squashed its migrations declares this column in no file, so the installer cannot
    # tell and writes this migration to be safe.
    return if column_exists?(:avo_ai_write_logs, :pending_write_id)

    add_column :avo_ai_write_logs, :pending_write_id, :bigint
    add_index :avo_ai_write_logs, :pending_write_id
  end
end
