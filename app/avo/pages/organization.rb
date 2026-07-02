class Avo::Pages::Organization < Avo::Forms::Core::Page
  self.title = "Organization"
  self.description = "A page for organization"

  def forms
    form Avo::Forms::Organization
  end
end
