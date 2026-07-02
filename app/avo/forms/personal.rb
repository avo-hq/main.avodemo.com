class Avo::Forms::Personal < Avo::Forms::Core::Form
  self.title = "Personals"
  self.description = "Manage your personals"

  def fields
    field :first_name, as: :text
    field :last_name, as: :text
  end

  def handle
    flash[:success] = { body: "Form submitted successfully", timeout: :forever }
    flash[:notice] = params[:example]

    current_user.update(first_name: params[:first_name], last_name: params[:last_name])

    default_response
  end
end
