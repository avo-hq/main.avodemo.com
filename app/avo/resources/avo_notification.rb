class Avo::Resources::AvoNotification < Avo::BaseResource
  self.model_class = ::Avo::Notifications::Notification
  self.title = :title
  self.includes = [:recipient, :sender]
  # Hide from sidebar by default; notifications are accessed via the bell icon.
  self.visible_on_sidebar = false
  self.default_view_type = :notification
  self.view_types = [:notification]

  self.index_query = -> {
    query.for_user(Avo::Current.user).newest_first
  }

  def fields
    field :id, as: :id
    field :level, as: :select, enum: ::Avo::Notifications::Notification.levels
    field :title, as: :text
    field :body, as: :textarea, only_on: [:show, :edit]
    field :url, as: :text, only_on: [:show]
    field :read_at, as: :date_time, sortable: true
    field :saved_at, as: :date_time, only_on: [:index, :show]
    field :marked_as_done_at, as: :date_time, name: "Done at", only_on: [:index, :show]
    field :created_at, as: :date_time, sortable: true
  end

  def scopes
    # "Done" notifications are archived out of every view except the Done scope.
    remove_scope_all
    scope Avo::Scopes::InboxNotifications, default: -> { true }
    scope Avo::Scopes::UnreadNotifications
    scope Avo::Scopes::ReadNotifications
    scope Avo::Scopes::SavedNotifications
    scope Avo::Scopes::DoneNotifications
  end

  def actions
    action Avo::Actions::MarkNotificationsAsRead
    action Avo::Actions::MarkNotificationsAsUnread
    action Avo::Actions::SaveNotifications
    action Avo::Actions::UnsaveNotifications
    action Avo::Actions::MarkNotificationsAsDone
    action Avo::Actions::MarkNotificationsAsUndone
  end
end
