class CreateAvoApiTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :avo_api_tokens do |t|
      t.string :name, null: false
      t.string :token_digest, null: false
      t.string :display_prefix, null: false
      t.string :owner_type, null: false
      t.bigint :owner_id, null: false
      t.datetime :expires_at
      t.datetime :revoked_at
      t.datetime :last_used_at
      t.json :entitlements

      t.timestamps
    end

    add_index :avo_api_tokens, :token_digest, unique: true
    add_index :avo_api_tokens, [:owner_type, :owner_id]
  end
end
