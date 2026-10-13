# Remote MCP servers a user connected from the chat, the tools each one offers, the always-allows
# people handed out on those tools, and the link from a remote call's card to its ruby_llm tool call.
#
# These arrived after the rest of avo-ai's schema did, so they are their own migration: an app that
# installed avo-ai before this version runs `bin/rails generate avo:ai install` again and gets
# exactly this file. A fresh install gets them from the create migration instead.
class CreateAvoAiConnectors < ActiveRecord::Migration[8.1]
  def change
    # A squashed app's files cannot tell the installer whether these exist, so the database settles
    # it, making this a no-op rather than a "relation already exists" halfway through a deploy.
    unless table_exists?(:avo_ai_connectors)
      create_table :avo_ai_connectors do |t|
        t.references :user, polymorphic: true, null: false
        # Where the remote server lives. Read-only once stored: the credentials were issued for this
        # host, so moving the row would send them somewhere else.
        t.string :server_url, null: false
        t.string :name              # what the server calls itself

        t.string :audience, null: false, default: "private" # private | everyone
        t.string :auth_kind, null: false, default: "none"   # none | oauth | token
        # pending while an OAuth sign-in is open, connected, needs_reconnect after a 401 or 403, a
        # failed refresh or a credential that will not decrypt.
        t.string :status, null: false, default: "pending"

        # A pasted bearer token, encrypted with Active Record encryption. OAuth credentials live in
        # ruby_llm's ruby_llm_mcp_credentials table instead, owned by this row.
        t.text :token

        t.timestamps
      end

      # The tools each server offered when last read, and the owner's setting for each.
      create_table :avo_ai_connector_tools do |t|
        t.references :connector, null: false, foreign_key: {to_table: :avo_ai_connectors}
        t.string :name, null: false
        t.text :description
        t.jsonb :argument_schema, null: false, default: {}
        # Over name, description and schema: what tells a stored always-allow that the remote server
        # changed the tool underneath it.
        t.string :digest, null: false
        t.string :policy, null: false, default: "on" # on | always_ask | off

        t.timestamps

        t.index [:connector_id, :name], unique: true
      end

      # One always-allow: this user, this tool, as the tool read when they allowed it.
      create_table :avo_ai_connector_grants do |t|
        t.references :user, polymorphic: true, null: false
        t.references :connector_tool, null: false, foreign_key: {to_table: :avo_ai_connector_tools}
        t.string :digest, null: false

        t.timestamps

        t.index [:user_type, :user_id, :connector_tool_id], unique: true,
          name: "index_avo_ai_connector_grants_on_user_and_tool"
      end
    end

    # The ruby_llm tool call a remote call's card stands for. Nil for every other card. Nullified,
    # not cascaded: the card is the audit record and outlives the transcript row.
    unless column_exists?(:avo_ai_pending_writes, :ruby_llm_tool_call_id)
      add_reference :avo_ai_pending_writes, :ruby_llm_tool_call, index: {unique: true},
        foreign_key: {to_table: :ruby_llm_tool_calls, on_delete: :nullify}
    end
  end
end
