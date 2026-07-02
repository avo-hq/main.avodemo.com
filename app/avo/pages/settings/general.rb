class Avo::Pages::Settings::General < Avo::Forms::Core::Page
  self.title = "General"
  self.description = "Manage your general settings"

  def content
    form Avo::Forms::Settings::AppSettings
    form Avo::Forms::Settings::ProfileSettings
  end
end
