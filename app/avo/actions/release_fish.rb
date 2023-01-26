class ReleaseFish < Avo::BaseAction
  self.name = "Release fish"
  self.message = "Are you sure you want to release this fish?"

  field :message, as: :trix, help: "Tell the fish something before releasing."
  field :user, as: :belongs_to, searchable: true, visible: ->(resource:) {
    resource.params[:id].present?
  }

  def handle(**args)
    args[:models].each do |model|
      model.release
    end

    succeed "#{args[:models].count} fish released with message '#{args[:fields][:message]}'."
  end
end
