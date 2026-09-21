# Registered on every resource but never authorized, so it should never appear
# in an actions list, a controls slot, or be runnable by URL. Visibility probe.
class Avo::Actions::UnauthorizedAction < Avo::BaseAction
  self.name = "Unauthorized action"
  self.authorize = -> { false }

  def handle(**args)
    error "This action should never have been runnable."
  end
end
