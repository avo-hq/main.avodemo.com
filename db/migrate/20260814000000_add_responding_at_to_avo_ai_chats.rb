class AddRespondingAtToAvoAiChats < ActiveRecord::Migration[8.1]
  def change
    add_column :avo_ai_chats, :responding_at, :datetime
  end
end
