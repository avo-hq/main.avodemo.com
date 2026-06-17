class Avo::ToolsController < Avo::ApplicationController
  def welcome
    @page_title = "Welcome"

    add_breadcrumb title: "Welcome"
  end

  def custom_page
    @page_title = "Your custom page"

    add_breadcrumb title: "Your custom page"
  end
end
