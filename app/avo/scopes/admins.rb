class Avo::Scopes::Admins < Avo::Scopes::BaseScope
  self.name = "Admins"
  self.description = "Admins only"
  self.scope = :admins
  self.visible = -> { true }
end
