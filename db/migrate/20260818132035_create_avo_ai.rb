class CreateAvoAi < ActiveRecord::Migration[8.1]
  def change
    # ruby_llm 2.0's split: the application owns chats and messages; RubyLLM owns its supporting
    # tables (models, tool calls, usage ledger, batches) under the `ruby_llm_` prefix — created
    # first because `avo_ai_chats` references `ruby_llm_models`, and mirrored here so
    # `avo:ai install` stays a one-command setup.

    # ---------------------------------------------------------------------------------------
    # RubyLLM 2.0's internal tables. `bin/rails generate ruby_llm:install` creates these for a
    # plain app; this block mirrors it so avo-ai installs without also generating (and then
    # deleting) ruby_llm's application Chat/Message models. Guarded, so an app that already ran
    # ruby_llm's own installer keeps its tables untouched. RubyLLM owns these tables' exact
    # shape — sync this block with the migration `ruby_llm:install` generates when upgrading.
    # ---------------------------------------------------------------------------------------

    unless table_exists?(:ruby_llm_models)
      create_table :ruby_llm_models do |t|
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
    end

    unless table_exists?(:ruby_llm_tool_calls)
      create_table :ruby_llm_tool_calls do |t|
        # The assistant message that requested the call, and the tool-result message answering
        # it — polymorphic, so custom message class names and primary keys need no mapping.
        t.references :message, polymorphic: true, null: false, index: false
        t.references :result, polymorphic: true, index: false

        t.string :tool_call_id, null: false
        t.string :name, null: false
        t.text :thought_signature

        # Tool-approval verdicts (`requires_approval` / `chat.approve!` / `chat.deny!`) persist
        # here so a parked loop survives restarts.
        t.string :approval

        t.jsonb :arguments, default: {}

        t.timestamps

        t.index [:message_type, :message_id]
        t.index [:result_type, :result_id]
        t.index :tool_call_id, unique: true
        t.index :name
      end
    end

    unless table_exists?(:ruby_llm_usage_entries)
      create_table :ruby_llm_usage_entries do |t|
        # One row per provider attempt — retries and cancelled streams included — linked to its
        # resulting message when one exists.
        t.references :chat, polymorphic: true, null: false, index: false
        t.references :message, polymorphic: true, index: false

        t.string :operation, null: false
        t.string :provider, null: false
        t.string :model, null: false
        t.string :status, null: false

        t.integer :input_tokens
        t.integer :output_tokens
        t.integer :cache_read_tokens
        t.integer :cache_write_tokens
        t.integer :thinking_tokens

        # Frozen decimal costs, priced when the attempt finished.
        t.decimal :input_cost, precision: 16, scale: 10
        t.decimal :output_cost, precision: 16, scale: 10
        t.decimal :cache_read_cost, precision: 16, scale: 10
        t.decimal :cache_write_cost, precision: 16, scale: 10
        t.decimal :thinking_cost, precision: 16, scale: 10
        t.decimal :total_cost, precision: 16, scale: 10

        t.timestamps

        t.index [:chat_type, :chat_id]
        t.index [:message_type, :message_id]
        t.index :status
        t.check_constraint "operation IN ('chat', 'embedding', 'moderation', 'image', 'speech', 'transcription')"
        t.check_constraint "status IN ('pending', 'succeeded', 'failed', 'cancelled')"
      end
    end

    unless table_exists?(:ruby_llm_batches)
      create_table :ruby_llm_batches do |t|
        t.string :provider_batch_id, null: false
        t.string :provider, null: false
        t.string :status
        t.boolean :completed, null: false, default: false
        t.string :chat_type
        t.string :batch_protocol
        t.json :chat_ids, default: []
        t.json :request_counts

        t.timestamps

        t.index [:provider, :provider_batch_id], unique: true
        t.index :status
      end
    end

    create_table :avo_ai_chats do |t|
      # The chat's model, resolved by RubyLLM's acts_as layer: assigning `model_id`/`provider`
      # stores a pending pair that a before_save resolves against the registry into a
      # `ruby_llm_models` row. Nullable — the association is optional, and a blank model falls
      # to the configured default at resolve time.
      t.references :ruby_llm_model, foreign_key: {to_table: :ruby_llm_models}
      t.references :user, polymorphic: true, null: false
      t.string :name
      t.jsonb :attached_context

      # ruby_llm 2.0's cross-process cancellation flag (`chat.cancel!`).
      t.boolean :cancelled, default: false, null: false

      # The run claim. Stamped when a response job takes the chat and released when it lets go, so
      # a message that reaches the server mid-run is answered by a further pass of the running job
      # instead of starting a second one alongside it (see Chat#run_claimed?).
      t.datetime :responding_at

      t.timestamps
    end

    create_table :avo_ai_messages do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_ai_chats}

      t.string :role, null: false
      t.text :content
      # Marks the last message covered by provider-side prompt caching (`message.cache_until_here!`).
      t.boolean :cache_until_here, null: false, default: false
      t.text :thinking_text
      t.text :thinking_signature
      # Normalized citations for assistant messages (`chat.with_citations`).
      t.json :citations
      # Provider-executed tool calls (web search and friends), normalized.
      t.json :server_tool_calls
      # The provider's raw content blocks, kept when a hook asks for them.
      t.json :raw_content
      # Why generation stopped, normalized across providers (`message.finish_reason`).
      t.string :finish_reason

      t.timestamps

      t.index :role
    end

    # Note what is GONE compared to the 1.x schema: the token/cost columns and the per-message
    # `model_id`/`provider` pair (the usage ledger above holds per-attempt counts, costs, and the
    # model that answered), `content_raw` (replaced by `raw_content`), and the app-owned
    # models/tool-calls tables.

    # An audit trail of every record the AI chat created, updated, or deleted. It outlives the
    # conversation transcript, so a write can still be reviewed — and reverted — long after the
    # tool result that described it has scrolled out of the model's context.
    create_table :avo_ai_write_logs do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_ai_chats}
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
    create_table :avo_ai_pending_writes do |t|
      t.references :chat, null: false, foreign_key: {to_table: :avo_ai_chats}
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
