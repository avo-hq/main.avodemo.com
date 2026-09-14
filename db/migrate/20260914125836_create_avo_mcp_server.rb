class CreateAvoMcpServer < ActiveRecord::Migration[8.1]
  def change
    # A connection is what an admin authorizes: one AI client, acting as one admin, with one set of
    # capabilities, until it is revoked. Everything else in this migration hangs off it.
    create_table :avo_mcp_server_connections do |t|
      # The admin the connection acts as. Polymorphic and deliberately WITHOUT a foreign key to
      # :users — the host names its own admin model, and every other gem here does the same.
      #
      # If that model uses UUID primary keys, add `type: :uuid` here BEFORE migrating. With no
      # foreign key nothing fails at migration time — the mismatch surfaces later, as owning-admin
      # lookups that quietly find nothing.
      t.references :user, polymorphic: true, null: false

      # On the primary (CIMD) path this is the HTTPS URL of the client's metadata document, which
      # is why it is a string rather than a reference to avo_mcp_server_clients: that path persists
      # no client row at all. On the DCR fallback it is the id this server minted.
      t.string :client_id, null: false
      # Whatever the client calls itself. Unverified — CIMD names come from the client's own
      # document and DCR lets any unauthenticated caller register any name — so the consent screen
      # shows it as claimed and leads with the client_id's origin instead.
      t.string :client_name

      # The capabilities the admin granted, as OAuth scope strings: avo:read, avo:write,
      # avo:actions — or per resource, as avo:read:Post and avo:write:Post.
      t.json :capabilities, null: false, default: []

      # Answers "was this connection ever used, and when?" after a suspected token theft. In a host
      # without avo-audit_logging, nothing anywhere else records that a connection did anything.
      t.datetime :last_used_at
      # Set once, never cleared. A revoked connection is kept rather than deleted so the admin can
      # still see that it existed and when it last ran.
      t.datetime :revoked_at

      t.timestamps

      t.index :client_id
      t.index :revoked_at
    end

    # The single-use authorization code an admin's approval mints, redeemed once at the token
    # endpoint and then dead.
    create_table :avo_mcp_server_access_grants do |t|
      t.references :connection, null: false, foreign_key: {to_table: :avo_mcp_server_connections}

      # SHA-256 of the code. Storing the code itself would put a live credential in every database
      # backup and every `SELECT *` a support engineer runs.
      t.string :code_digest, null: false

      # The capabilities this code carries. Copied from the connection at approval rather than read
      # through it, so narrowing a connection later cannot retroactively widen a code in flight.
      t.json :capabilities, null: false, default: []

      # PKCE. The method is stored alongside the challenge so a redemption verifies against what was
      # actually agreed at authorize time, not against whatever the token request claims.
      t.string :code_challenge, null: false
      t.string :code_challenge_method, null: false, default: "S256"

      # Both are re-checked at redemption. Every client here is public, so nothing authenticates the
      # caller at the token endpoint — the redirect URI and the client_id binding are the only thing
      # standing between a code and a client mix-up.
      t.string :redirect_uri, null: false
      t.string :client_id, null: false

      t.datetime :expires_at, null: false
      # Stamped by the redemption that consumed it. Presence, not deletion, is what makes the code
      # single-use: a replay has to be recognizable, and a deleted row is indistinguishable from a
      # code that never existed.
      t.datetime :redeemed_at
      t.datetime :revoked_at

      t.timestamps

      t.index :code_digest, unique: true
      t.index :expires_at
    end

    # One row per issuance: an access token and the refresh token that replaces it.
    create_table :avo_mcp_server_access_tokens do |t|
      t.references :connection, null: false, foreign_key: {to_table: :avo_mcp_server_connections}

      # Digests only, both of them. The unique indexes are also what make a digest collision a
      # database error rather than a silent authentication of the wrong connection.
      t.string :access_token_digest, null: false
      t.string :refresh_token_digest, null: false

      # Every token minted by rotating another shares its predecessor's family. Reuse detection
      # revokes the family, so a stolen refresh token cannot be laundered into a fresh one that
      # outlives the revocation.
      t.string :family_id, null: false

      t.datetime :expires_at, null: false
      t.datetime :refresh_expires_at, null: false

      # Stamped when this token's refresh token was spent. It is the whole of reuse detection:
      # a rotated token presented again inside the grace window is an ordinary client retry, and
      # the same token presented after it is a token that should no longer exist anywhere.
      t.datetime :rotated_at
      t.datetime :revoked_at

      t.timestamps

      t.index :access_token_digest, unique: true
      t.index :refresh_token_digest, unique: true
      t.index :family_id
    end

    # Dynamic Client Registration fallback only. The primary path identifies a client by a metadata
    # document the server re-fetches from the client_id URL, so it needs no row here; a DCR client
    # has no document to re-fetch, so its registration is all there is.
    create_table :avo_mcp_server_clients do |t|
      # The authorization server issuer that minted this credential, and the credential itself. The
      # pair is unique rather than the client_id alone: a client_id means nothing outside the issuer
      # that produced it, and an app whose issuer changes must not keep honoring the old issuer's
      # registrations.
      t.string :issuer, null: false
      t.string :client_id, null: false

      t.string :client_name
      # "web" or "native" per RFC 7591. A native client redirects to a loopback address on a port it
      # picks at runtime, so redirect matching has to treat it differently from a hosted one.
      t.string :application_type
      t.json :redirect_uris, null: false, default: []

      # Null for a public client, which is every client this server expects. Hashed for the same
      # reason the tokens are, on the chance a confidential one ever registers.
      t.string :client_secret_digest

      t.timestamps

      t.index [:issuer, :client_id], unique: true
    end

    # One row per request a connection made: what was asked, how it went, and how long it took.
    # The connections resource shows them live on a connection's page. Rows are pruned on insert
    # to config.mcp_server.connection_log_size per connection, so the table cannot grow without
    # bound however busy an agent is.
    create_table :avo_mcp_server_events do |t|
      t.references :connection, null: false, index: false, foreign_key: {to_table: :avo_mcp_server_connections}

      # The JSON-RPC method — tools/call, tools/list, initialize — and, for a tool call, the tool
      # and the resource it named.
      t.string :rpc_method, null: false
      t.string :tool_name
      t.string :resource_name

      # ok, error (a JSON-RPC error), tool_error (the tool answered isError), refused (a malformed
      # request), rate_limited, or rejected (a token that no longer authenticates).
      t.string :outcome, null: false
      t.integer :error_code
      t.text :error_message

      # A tool call's arguments, after the app's filter_parameters and capped in size.
      t.json :arguments
      t.integer :duration_ms

      t.datetime :created_at, null: false

      # The one query the panel makes: this connection's newest rows, and those after an id.
      t.index [:connection_id, :id]
    end
  end
end
