class Avo::Actions::BulkDestroy < Avo::BaseAction
  self.name = "Bulk Destroy"
  self.message = -> {
    tag.div do
      safe_join([
        "Are you sure you want to delete these #{query.count} records?",
        tag.div(class: "text-sm text-gray-500 mt-2 mb-2 font-bold") do
          "These records will be permanently deleted:"
        end,
        tag.ul(class: "ml-4 overflow-y-scroll max-h-64") do
          safe_join(query.map do |record|
            tag.li(class: "text-sm text-gray-500") do
              "- #{::Avo.resource_manager.get_resource_by_model_class(record.class).new(record:).record_title}"
            end
          end)
        end,
        tag.div(class: "text-sm text-red-500 mt-2 font-bold") do
          "This action cannot be undone."
        end
      ])
    end
  }

  def handle(query:, **)
    query.each(&:destroy!)
    succeed "Deleted #{query.count} records"
  rescue => e
    fail "Failed to delete #{query.count} records: #{e.message}"
  end
end
