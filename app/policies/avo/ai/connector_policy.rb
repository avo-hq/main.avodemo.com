# Replaces the gem's policy, which refuses create? and share? for everyone. Plain class on purpose
# (no ApplicationPolicy): the gem instantiates it directly and Scope#resolve asks create? about the
# owner of a shared connection, so every answer must read `user`, never a current-user global.
class Avo::Ai::ConnectorPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create? = enabled? && admin? # connecting a server
  def share? = enabled? && admin?  # sharing one with everyone in the admin
  def index? = enabled?
  def show? = enabled?
  def new? = create?
  def edit? = update?
  # Tool settings, Refresh tools, Revoke always-allows.
  def update? = enabled? && owner?
  # Disconnect.
  def destroy? = enabled? && owner?
  # Authorized separately from CRUD: without them the resource's search box and actions vanish.
  def search? = enabled?
  def act_on? = enabled?

  # Tool rows come from the server: the connection page's tools table offers no attach, detach or create.
  def attach_connector_tools? = false
  def detach_connector_tools? = false
  def create_connector_tools? = false

  private

  def enabled? = Avo.configuration.ai.connectors_enabled
  def admin? = !!user&.admin?
  def owner? = record.respond_to?(:owned_by?) && record.owned_by?(user)

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # The user's own connections, plus shared ones whose owner may still connect, so a shared
    # connection stops for everyone once its owner loses the permission.
    def resolve
      return @scope.none unless Avo.configuration.ai.connectors_enabled

      mine = @scope.where(user_type: @user.class.name, user_id: @user.id)
      usable = @scope.where(audience: "everyone").includes(:user).select do |connector|
        connector.user && Avo::Ai::ConnectorPolicy.new(connector.user, connector).create?
      end

      mine.or(@scope.where(id: usable.map(&:id)))
    end
  end
end
