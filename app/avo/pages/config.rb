class Avo::Pages::Config < Avo::Forms::Core::Page
  self.title = "Config"
  self.description = "A page for config"

  def sub_pages
    sub_page Avo::Pages::Organization, default: true
    sub_page Avo::Pages::Profile
  end
end
