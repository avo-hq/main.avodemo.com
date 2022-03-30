class Avo::ToolsController < Avo::ApplicationController
  def custom_page
    @page_title = "Your custom page"

    add_breadcrumb "Your custom page"
  end
end
