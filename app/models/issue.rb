class Issue < ApplicationRecord
  # Shared with PullRequest and Task so they can all live on the same kanban
  # board. The board groups records by their `status`, matching each column's
  # `value`.
  STATUSES = ["Backlog", "Todo", "In Progress", "In Review", "Done"].freeze
  PRIORITIES = ["Low", "Medium", "High", "Urgent"].freeze
  # Chip tones for the shared status set, read by the Issue, PullRequest and Task resources.
  STATUS_TONES = {"Backlog" => :muted, "Todo" => :neutral, "In Progress" => :info, "In Review" => :warning, "Done" => :success}.freeze

  # Badge colors for each priority, shown on the kanban card.
  PRIORITY_COLORS = {
    "Low" => "#6b7280",
    "Medium" => "#0969da",
    "High" => "#d93f0b",
    "Urgent" => "#b60205"
  }.freeze

  validates :title, presence: true

  # Remove this record's kanban cards with it; otherwise the board 500s on the
  # orphaned item (Avo::Kanban::ItemComponent.resource_for on a nil record).
  has_many :kanban_items, class_name: "Avo::Kanban::Item", as: :record, dependent: :destroy

  default_scope { order(number: :asc) }

  def name
    [("#" + number.to_s if number.present?), title].compact.join(" ")
  end

  # ---- Optional kanban card display hooks (read by WorkItemComponent) ----
  def kanban_icon
    {svg: "tabler/filled/circle-dot", classes: "text-success"}
  end

  def kanban_reference
    number
  end

  def kanban_badges
    return [] if priority.blank?

    [{label: priority, color: PRIORITY_COLORS[priority]}]
  end

  def kanban_assignee
    author
  end
end
