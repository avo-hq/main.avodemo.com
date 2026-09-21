# Authorizes the API tokens resource (avo-api). The gem ships no policy for it on
# purpose — who may mint a credential is the app's call — and with
# `config.explicit_authorization = true` the resource stays unreachable until one
# answers `index?`, so the sidebar entry would 403 without this file.
#
# Every demo visitor signs in as the same shared admin, so the per-owner scope the
# docs show (`scope.where(owner: user)`) would be a no-op here; keep it as
# permissive as the other demo policies. Minting stays open because the one-time
# secret reveal is the thing worth showing, and `avodemo:reset` wipes the table
# nightly anyway.
# https://docs.avohq.io/4.0/rest-api.html#who-may-manage-tokens
class Avo::Api::TokenPolicy < ApplicationPolicy
  def index? = true
  def show? = true

  def create? = true
  def new? = create?

  def update? = true
  def edit? = update?

  def destroy? = true

  # Revoke. Avo asks once for the action itself (record is the class), then per
  # selected token.
  def act_on? = true
  def revoke? = true

  # The Entitlements grid. Denied would render it read-only rather than hide it;
  # spelled out so a later restriction has a place to land.
  def edit_entitlements? = true

  class Scope < ApplicationPolicy::Scope
    def resolve = scope.all
  end
end
