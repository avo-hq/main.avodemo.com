class CoursePolicy < BaseAvoPolicy
  # The `links` has_many renders as a nested form (avo-nested). With
  # explicit_authorization, Avo denies a missing per-association method, which
  # hides the field and its nested Add/Edit controls. Permissive here so nested
  # creation/editing works — same pattern as TeamPolicy's `*_memberships?`.
  def view_links? = true
  def show_links? = true
  def create_links? = true
  def edit_links? = true
  def attach_links? = true
  def detach_links? = true
  def destroy_links? = true
  def act_on_links? = true

  # Custom `Avo::CoursesController#cities` action (the country→cities dropdown
  # JSON endpoint) routes through Avo's authorize_action, which asks Pundit for
  # `cities?`. With explicit_authorization a missing method raises NoMethodError,
  # so define it. Permissive to match the demo intent.
  def cities? = true
end
