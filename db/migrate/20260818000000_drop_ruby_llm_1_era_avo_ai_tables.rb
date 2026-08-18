class DropRubyLlm1EraAvoAiTables < ActiveRecord::Migration[8.1]
  # avo-ai alpha.19 (ruby_llm 2.0) has no in-place upgrade — old transcripts are
  # discarded by design; the install generator recreates the schema fresh.
  def up
    drop_table :avo_ai_pending_writes, if_exists: true
    drop_table :avo_ai_write_logs, if_exists: true
    # messages<->tool_calls FKs are circular; cascade cuts the knot
    drop_table :avo_ai_tool_calls, if_exists: true, force: :cascade
    drop_table :avo_ai_messages, if_exists: true, force: :cascade
    drop_table :avo_ai_chats, if_exists: true, force: :cascade
    drop_table :avo_ai_models, if_exists: true, force: :cascade
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
