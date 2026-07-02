class Avo::Pages::Profile < Avo::Forms::Core::Page
  self.title = "Profile"
  self.description = "A page for profile"

  def forms
    form Avo::Forms::Personal
  end
end
