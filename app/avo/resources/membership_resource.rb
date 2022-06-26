class MembershipResource < Avo::BaseResource
  self.title = :id
  self.includes = [:user, :team]
  self.model_class = "TeamMembership"

  field :id, as: :id
  field :level, as: :select, options: { 'Beginner': :beginner, 'Intermediate': :intermediate, 'Advanced': :advanced }, display_value: true, default: -> { Time.now.hour < 12 ? 'advanced' : 'beginner' }
  field :user, as: :belongs_to
  field :team, as: :belongs_to
end