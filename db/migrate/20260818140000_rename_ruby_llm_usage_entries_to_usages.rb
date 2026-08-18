class RenameRubyLlmUsageEntriesToUsages < ActiveRecord::Migration[8.1]
  # avo-ai alpha.19's install template still creates `ruby_llm_usage_entries`, but
  # ruby_llm main renamed the table — RubyLLM::ActiveRecord::Usage sets
  # `self.table_name = "ruby_llm_usages"` (lib/ruby_llm/active_record/usage.rb:7), and
  # every avo-ai reader goes through the `ruby_llm_usages` association. Without this,
  # any message that records usage raises PG::UndefinedTable.
  # Guarded so it no-ops once avo-ai's template catches up.
  def up
    return unless table_exists?(:ruby_llm_usage_entries)
    return if table_exists?(:ruby_llm_usages)

    rename_table :ruby_llm_usage_entries, :ruby_llm_usages
  end

  def down
    return unless table_exists?(:ruby_llm_usages)

    rename_table :ruby_llm_usages, :ruby_llm_usage_entries
  end
end
