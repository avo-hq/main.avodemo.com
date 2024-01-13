class Avo::Actions::Dummy < Avo::BaseAction
  self.name = "Dummy action"
  self.standalone = true
  self.visible = -> { view.index? }

  def handle(**args)
    # Do something here

    puts 'DummyAction triggered'

    succeed 'Yup'
  end
end
