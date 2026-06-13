class Avo::Resources::Author < Avo::Core::Resources::Http
  self.icon = "heroicons/outline/academic-cap"
  self.description = -> {
    "Authors fetched live from <a href='https://docs.openalex.org' target='_blank'>https://docs.openalex.org</a> — a read-only HTTP resource (avo-http_resource), no local database table.".html_safe
  }
  self.title = :display_name
  self.record_selector = false
  self.visible_on_sidebar = false

  self.http_adapter = {
    endpoint: "https://api.openalex.org/authors",
    parse_collection: -> {
      raise Avo::HttpError.new response["message"] if response["error"].present?

      response["results"]
    },
    parse_record: -> {
      raise Avo::HttpError.new response["message"] if response["error"].present?

      response
    },
    parse_count: -> {
      response["meta"]["count"]
    },
    # Encodes the ID for use in URL helpers. The `model_class_eval` block is executed when the model is defined in memory,
    # allowing us to override `to_param` and obfuscate the raw ID via Base64 encoding.
    model_class_eval: -> {
      define_method :to_param do
        return nil if try(:id).nil?

        Base64.encode64(id)
      end
    },
    query_params: -> {
      if params[:sort_by] == "name"
        {sort: "display_name:#{params[:sort_direction]}"}
      elsif params[:sort_by].present?
        {sort: "#{params[:sort_by]}:#{params[:sort_direction]}"}
      end
    },
  }

  # This is required only when the ID includes characters (e.g., ".") that could be improperly routed.
  self.find_record_method = -> { query.find Base64.decode64(id) }

  def fields
    field :id, as: :id
    field :name, sortable: true do
      names = [record.display_name]

      alternatives = record.display_name_alternatives - Array.wrap(record.display_name)

      if alternatives.present?
        tooltip = "Alternative names<br><br>" + alternatives.map { |name| "- #{name}" }.join("<br>")
        names << tag.span("ⓘ", class: "inline-block ml-1 text-sm text-gray-400 cursor-help", data: { tippy: "tooltip", tippy_content: tooltip })
      end

      safe_join(names)
    end

    field :cited_by_count, sortable: true,
      name: "Total citations",
      format_using: -> { value&.to_i&.positive? ? value : nil },
      html: {index: {wrapper: {classes: "text-right p-2"}}}

    field :works_count, sortable: true,
      name: "Total works",
      format_using: -> { value&.to_i&.positive? ? value : nil },
      html: {index: {wrapper: {classes: "text-right p-2"}}}

    field :last_known_institutions do
      if record.last_known_institutions&.any?
        institutions = [record.last_known_institutions.first.display_name]

        if record.last_known_institutions[1...].any?
          tooltip = "Full list<br><br>" + record.last_known_institutions.map { |institution| "- #{institution.display_name}" }.join("<br>")
          institutions << tag.span(", ... ⓘ", class: "inline-block ml-1 text-sm text-gray-400 cursor-help", data: { tippy: "tooltip", tippy_content: tooltip })
        end

        safe_join(institutions)
      end
    end
  end
end
