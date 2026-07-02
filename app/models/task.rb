class Task < ApplicationRecord
  # Reuse Issue's shared status set so issues, pull requests and tasks can all
  # be placed on the same kanban board (grouped by `status`).
  STATUSES = Issue::STATUSES

  validates :title, presence: true

  default_scope { order(created_at: :asc) }

  def name
    title
  end

  # ---- Optional kanban card display hooks (read by WorkItemComponent) ----
  def kanban_icon
    {svg: "tabler/filled/circle-check", classes: "text-content-secondary"}
  end

  # Tasks have no issue/PR number, so they show no reference tag.
  def kanban_reference
    nil
  end

  def kanban_badges
    return [] if due_on.blank?

    [{label: "Due #{due_on.strftime("%b %-d")}", color: "#d93f0b"}]
  end

  def kanban_assignee
    assignee
  end
end
