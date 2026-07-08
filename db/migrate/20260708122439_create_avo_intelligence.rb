class CreateAvoIntelligence < ActiveRecord::Migration[8.1]
  def change
    create_table :avo_intelligence_models do |t|
      t.string :model_id, null: false
      t.string :name, null: false
      t.string :provider, null: false
      t.string :family
      t.datetime :model_created_at
      t.integer :context_window
      t.integer :max_output_tokens
      t.date :knowledge_cutoff

      t.jsonb :modalities, default: {}
      t.jsonb :capabilities, default: []
      t.jsonb :pricing, default: {}
      t.jsonb :metadata, default: {}

      t.timestamps

      t.index [:provider, :model_id], unique: true
      t.index :provider
      t.index :family
      t.index :capabilities, using: :gin
      t.index :modalities, using: :gin
    end

    create_table :avo_intelligence_chats do |t|
      t.references :model, foreign_key: {to_table: :avo_intelligence_models}
      t.references :user, polymorphic: true, null: false
      t.string :name

      t.timestamps
    end

    # Created without :message_id first — avo_intelligence_messages references tool calls too,
    # so the two tables have a circular dependency. The reference back to messages is added
    # below with add_reference, once the messages table exists.
    create_table :avo_intelligence_tool_calls do |t|
      t.string :tool_call_id, null: false
      t.string :name, null: false
      t.text :thought_signature

      t.jsonb :arguments, default: {}

      t.timestamps

      t.index :tool_call_id, unique: true
      t.index :name
    end

    create_table :avo_intelligence_messages do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_intelligence_chats}
      t.references :model, foreign_key: {to_table: :avo_intelligence_models}
      t.references :tool_call, foreign_key: {to_table: :avo_intelligence_tool_calls}

      t.string :role, null: false
      t.text :content
      t.json :content_raw
      t.text :thinking_text
      t.text :thinking_signature
      t.integer :thinking_tokens
      t.integer :input_tokens
      t.integer :output_tokens
      t.integer :cached_tokens
      t.integer :cache_creation_tokens

      t.timestamps

      t.index :role
    end

    add_reference :avo_intelligence_tool_calls, :message, null: false, foreign_key: {to_table: :avo_intelligence_messages}

    # An audit trail of every record the AI chat created, updated, or deleted. It outlives the
    # conversation transcript, so a write can still be reviewed — and reverted — long after the
    # tool result that described it has scrolled out of the model's context.
    create_table :avo_intelligence_write_logs do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_intelligence_chats}
      t.references :user, polymorphic: true, null: false

      t.string :resource, null: false    # Avo resource name the tool acted on, e.g. "Comment"
      t.string :record_type, null: false # model class name, e.g. "Comment"
      t.string :record_id, null: false   # primary key value as a string (supports non-integer PKs)
      t.string :action, null: false      # create | update | delete

      # Full attribute snapshots, minus restricted fields. before is nil for a create, after is
      # nil for a delete; both are present for an update. This is what a revert reads to reverse
      # the change.
      t.jsonb :before_snapshot
      t.jsonb :after_snapshot

      t.datetime :reverted_at # set once this write has been undone, so it is not undone twice

      t.timestamps

      t.index [:chat_id, :created_at]
    end

    # A destructive chat write (update / delete / undo) proposed by the assistant and AWAITING the
    # user's explicit confirmation. The tool only ever creates a row here; the write itself runs
    # later, when the user clicks Confirm on the card — so the model can never force it through by
    # passing a "confirmed" flag. One row per proposal; status moves pending → confirmed/cancelled.
    create_table :avo_intelligence_pending_writes do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_intelligence_chats}
      t.references :user, polymorphic: true, null: false

      t.string :action, null: false                     # update | delete | revert
      t.string :status, null: false, default: "pending"  # pending | confirmed | cancelled | failed

      t.string :resource    # Avo resource name, e.g. "Comment"
      t.string :record_type # model class name, e.g. "Comment"
      t.string :record_id   # primary key value as a string

      # Everything the executor needs to perform the write deterministically, without trusting the
      # model again: for update, the resolved {column => value} attributes; for revert, the
      # write_log_id to undo. Empty for a plain delete (resource + record_id are enough).
      t.jsonb :payload, null: false, default: {}

      t.timestamps

      t.index [:chat_id, :status]
    end
  end
end
