class AddSlugToAvoMcpServerConnections < ActiveRecord::Migration[8.1]
  # Written by `bin/rails generate avo:mcp_server install` for an app whose connections table
  # predates the name column; a fresh install has it in its one migration (AVO-1814).
  def up
    # The connection's name, generated when the admin approves it: three words, unique, readable
    # aloud — `creamy-golden-hass`. The row's title in the panel, and what the server tells the
    # client at `initialize`, so a session and a row can be matched by name.
    add_column :avo_mcp_server_connections, :slug, :string
    add_index :avo_mcp_server_connections, :slug, unique: true

    # Every connection that predates names gets one, the way a new connection does, so the panel
    # and the session can name every row.
    Avo::McpServer::Connection.name_unnamed!
  end

  def down
    remove_column :avo_mcp_server_connections, :slug
  end
end
