class Avo::Forms::Settings::ProfileSettings < Avo::Forms::Core::Form
  self.title = "Profile Settings"
  self.description = "Manage your profile settings."

  def fields
    card do
      with_options record: Avo::Current.user, width: 50 do
        field :first_name, help: "Notice your name changes on the bottom left corner of the page. 😊"
        field :last_name
      end

      field :email, record: Avo::Current.user, disabled: true
    end
  end

  def handle
    if params[:email].present? && params[:email] != current_user.email
      flash[:error] = "Email cannot be changed. 😊 Nice try! 😏"
    end

    current_user.update(params.permit(:first_name, :last_name))

    flash[:success] = "Profile updated successfully. 😊"

    default_response
  end
end
