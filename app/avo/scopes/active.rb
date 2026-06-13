class Avo::Scopes::Active < Avo::Scopes::BaseScope
  self.name = "Active"
  self.description = "Active only"
  self.scope = :active
  self.visible = -> { true }
end
