class Avo::Scopes::Admins < AvoPro::Scopes::BaseScope
  self.name = "Admins"
  self.description = "Admins only"
  self.scope = :admins
  self.visible = -> { true }
end
