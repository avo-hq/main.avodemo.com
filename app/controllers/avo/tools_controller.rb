class Avo::ToolsController < Avo::ApplicationController
  def custom_page
    @page_title = "Your custom page"

    add_breadcrumb title: "Your custom page"
  end
end
