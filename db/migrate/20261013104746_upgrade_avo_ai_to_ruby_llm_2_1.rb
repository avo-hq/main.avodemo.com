# ruby_llm 2.1's MCP additions: the table its OAuth credentials are stored in, and the column a
# tool call waiting on the user's input keeps its request in. Mirrors ruby_llm's own
# upgrade_ruby_llm_to_2_1 migration, guarded the same way, so an app that also ran
# `bin/rails generate ruby_llm:upgrade` gets no error from running both.
#
# An app that installed avo-ai before this version runs `bin/rails generate avo:ai install` again
# and gets this file. A fresh install gets both from the create migration instead.
#
# The class name is the file name camelized under the app's inflections, as ruby_llm's own is: an
# app with an "LLM" acronym camelizes ruby_llm differently.
class UpgradeAvoAiToRubyLlm21 < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:ruby_llm_mcp_credentials)
      create_table :ruby_llm_mcp_credentials do |t|
        t.references :owner, polymorphic: true
        t.string :key, null: false
        t.text :data

        t.timestamps

        t.index :key, unique: true
      end
    end

    unless column_exists?(:ruby_llm_tool_calls, :pending_input)
      add_column :ruby_llm_tool_calls, :pending_input, :jsonb
    end
  end
end
