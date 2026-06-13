class Avo::Forms::Organization < Avo::Forms::Core::Form
  self.title = "Organizations"
  self.description = "Manage your organizations"

  def fields
    field :name, as: :text
    field :domain
  end

  def handle
    flash[:success] = { body: "Form submitted successfully (demo — not persisted)", timeout: :forever }
    flash[:notice] = params[:example]

    default_response
  end
end
