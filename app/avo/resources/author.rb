class Avo::Resources::Author < Avo::Core::Resources::Http
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
    parse_count: -> { response["meta"]["count"] },
    ## This is required only when the ID includes characters (e.g., ".") that could be improperly routed.
    ## Encodes the ID for use in URL helpers. The `model_class_eval` block is executed when the model is defined in memory,
    ## allowing us to override `to_param` and obfuscate the raw ID via Base64 encoding.
    model_class_eval: -> {
      define_method :to_param do
        Base64.encode64(id)
      end
    }
  }

  self.find_record_method = -> { query.find Base64.decode64(id) }

  self.authorization_policy = AuthorPolicy

  def fields
    field :id, as: :id
    field :display_name
  end
end
