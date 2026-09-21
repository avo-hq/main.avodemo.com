class RenameAvoApiTokenScopes < ActiveRecord::Migration[8.1]
  # Was `scopes` in avo-api 4.2.0, the one version that shipped it under that
  # name. "Scope" already means a policy scope in Avo and an ActiveRecord scope
  # in every app running it, so the column that decides what a token reaches is
  # called `entitlements` from 4.3.0 on.
  #
  # Guarded rather than unconditional, because both migrations ship in the same
  # generator: a fresh install creates `entitlements` above and then arrives
  # here with nothing to rename. Reversible for the same reason -- rolling back
  # an install that never had `scopes` must not invent one.
  def up
    return unless column_exists?(:avo_api_tokens, :scopes)

    rename_column :avo_api_tokens, :scopes, :entitlements
  end

  def down
    return unless column_exists?(:avo_api_tokens, :entitlements)

    rename_column :avo_api_tokens, :entitlements, :scopes
  end
end
