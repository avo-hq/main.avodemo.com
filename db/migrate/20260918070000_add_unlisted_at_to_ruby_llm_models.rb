class AddUnlistedAtToRubyLlmModels < ActiveRecord::Migration[8.1]
  # ruby_llm 2.0.0 final added this column to its install template; the mirror in
  # 20260818132035_create_avo_ai.rb predates it.
  def change
    add_column :ruby_llm_models, :unlisted_at, :datetime unless column_exists?(:ruby_llm_models, :unlisted_at)
  end
end
