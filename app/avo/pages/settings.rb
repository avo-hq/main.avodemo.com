class Avo::Pages::Settings < Avo::Forms::Core::Page
  self.title = "Settings"
  self.description = "Manage your settings"

  def navigation
    page Avo::Pages::Settings::General, default: true
    page form: Avo::Forms::Settings::Integrations
    page "Feedback", description: "Give us feedback", content: -> do
      form Avo::Forms::Settings::AnonymousFeedback
      form Avo::Forms::Settings::Rating
    end
  end
end

module Avo
  module Forms
    module Settings
      class AnonymousFeedback < Avo::Forms::Core::Form
        def fields
          field :anonymous_feedback, as: :textarea, help: "This is just a dummy form"
        end

        def handle
          flash[:success] = "Feedback NOT submitted, this is just a dummy form"
          default_response
        end
      end

      class Rating < Avo::Forms::Core::Form
        def fields
          field :rating, as: :number, help: "This is just a dummy form", max: 5, min: 1, step: 1, default: 3
        end

        def handle
          flash[:success] = "Rating #{params[:rating]} NOT submitted, this is just a dummy form"
          default_response
        end
      end
    end
  end
end
