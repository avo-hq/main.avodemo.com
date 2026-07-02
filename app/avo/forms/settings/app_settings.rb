class Avo::Forms::Settings::AppSettings < Avo::Forms::Core::Form
  def fields
    field :url, components: { edit_component: Avo::Fields::TextField::ShowComponent } do
      tag.div do
        safe_join([
          link_to("https://main.avodemo.com/", "https://main.avodemo.com/", target: "_blank"),
          tag.div(class: "text-sm text-gray-600 pt-2") do
            safe_join([
              tag.p("This is the URL of the app."),
              tag.p("Its just a demonstration of how to use a show component to display something on a form. 😊")
            ])
          end
        ])
      end.html_safe
    end

    field :name,
      format_using: -> { Avo.configuration.app_name },
      help: "This is the name of the app. The value is stored in a cookie. Change it, hit save and verify the change on the top left corner of the page."
  end

  def handle
    cookies[:app_name] = params[:name]
    flash[:success] = "App settings updated successfully. 😊"
    default_response
  end
end
