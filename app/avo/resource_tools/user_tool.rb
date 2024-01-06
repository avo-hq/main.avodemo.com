class Avo::ResourceTools::UserTool < Avo::BaseResourceTool
  self.name = "User tool"
  # self.partial = "avo/resource_tools/user_tool"

  attr_reader :foo

  def initialize(**kwargs)
    super **kwargs

    @foo = :bar
  end

  def custom_method_call
    :called
  end
end
