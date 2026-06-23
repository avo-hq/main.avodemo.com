class Course::LinkPolicy < BaseAvoPolicy
  # When Course's `links` has_many renders as a NESTED form (avo-nested) on
  # new/edit, Avo hydrates the field with the CourseLink resource, so the
  # field's `authorized?` check (`view_links?`) is evaluated against THIS policy,
  # not CoursePolicy. Under explicit_authorization a missing method is denied,
  # which hides the nested form on the Course form. Permissive here to match the
  # demo intent. (CoursePolicy carries the same set for the show view + saving.)
  def view_links? = true
  def show_links? = true
  def create_links? = true
  def edit_links? = true
  def attach_links? = true
  def detach_links? = true
  def destroy_links? = true
  def act_on_links? = true
end
