class PullRequest < ApplicationRecord
  # Reuse Issue's shared status set so issues, pull requests and tasks can all
  # be placed on the same kanban board (grouped by `status`).
  STATUSES = Issue::STATUSES

  validates :title, presence: true

  default_scope { order(number: :asc) }

  def name
    [("#" + number.to_s if number.present?), title].compact.join(" ")
  end

  # ---- Optional kanban card display hooks (read by WorkItemComponent) ----
  def kanban_icon
    if draft?
      {svg: "tabler/outline/git-pull-request", classes: "text-content-secondary"}
    else
      {svg: "tabler/outline/git-merge", classes: "text-success"}
    end
  end

  def kanban_reference
    number
  end

  def kanban_badges
    badges = []
    badges << {label: "Draft", color: "#6b7280"} if draft?
    badges << {label: branch, color: "#0969da"} if branch.present?
    badges
  end

  def kanban_assignee
    author
  end
end
