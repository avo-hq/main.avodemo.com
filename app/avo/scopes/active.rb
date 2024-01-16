class Avo::Scopes::Active < Avo::Advanced::Scopes::BaseScope
  self.name = "Active"
  self.description = "Active only"
  self.scope = :active
  self.visible = -> { true }
end
