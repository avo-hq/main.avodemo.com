class Avo::Actions::Dummy < Avo::BaseAction
  self.name = "Dummy action"
  self.standalone = true
  self.visible = -> { view.index? }

  def fields
    field :size, as: :radio, options: {small: "Small Option", medium: "Medium Option", large: "Large Option"}
  end

  def handle(**args)
    # Do something here

    puts 'DummyAction triggered'

    succeed 'Yup'
  end
end
