class AddAttachedContextToAvoIntelligenceChats < ActiveRecord::Migration[8.1]
  def change
    add_column :avo_intelligence_chats, :attached_context, :jsonb
  end
end
