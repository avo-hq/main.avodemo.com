class RenameAvoIntelligenceTablesToAvoAi < ActiveRecord::Migration[8.1]
  def change
    # ponytail: rename_table only; old auto-generated index names are harmless
    %w[chats messages models tool_calls pending_writes write_logs].each do |suffix|
      rename_table :"avo_intelligence_#{suffix}", :"avo_ai_#{suffix}"
    end
  end
end
