# frozen_string_literal: true

# Rich, GitHub-Projects-style kanban card for work items (issues, pull requests
# and tasks). It lives in the app so the gem's generic
# `Avo::Kanban::Items::ItemComponent` stays simple; resources opt in by overriding
# that component through Avo's `self.components`.
#
# Presentation data comes from optional hooks on the record (`kanban_icon`,
# `kanban_reference`, `kanban_badges`, `kanban_assignee`); this component only
# lays them out.
class Avo::Kanban::Items::WorkItemComponent < Avo::Kanban::Items::ItemComponent
  def record
    @item.record
  end

  # A leading type icon: { svg: "tabler/filled/circle-dot", classes: "text-success" }.
  def card_icon
    record.kanban_icon if record.respond_to?(:kanban_icon)
  end

  # The card reference, e.g. an issue/PR number shown as `#142`.
  def card_reference
    record.kanban_reference if record.respond_to?(:kanban_reference)
  end

  # Metadata tags: [{ label: "bug", color: "#d73a4a" }, ...]. `color` is optional.
  def card_badges
    record.respond_to?(:kanban_badges) ? Array(record.kanban_badges) : []
  end

  # The person associated with the card, rendered as an initials avatar.
  def card_assignee
    record.kanban_assignee if record.respond_to?(:kanban_assignee)
  end

  def assignee_initials
    card_assignee.to_s.split.map { |part| part[0] }.first(2).join.upcase
  end
end
