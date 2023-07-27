class Avo::Scopes::NonAdmins < Avo::Pro::Scopes::BaseScope
  self.name = "Non admins"
  self.description = "Non admins"
  self.scope = :non_admins
  self.visible = -> { true }
end
