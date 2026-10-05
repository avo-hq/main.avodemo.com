class Avo::Resources::HttpTeam < Avo::Core::Resources::Http
  self.icon = "heroicons/outline/cloud"
  self.title = :name
  self.description = "Demo HTTP resource with custom writes. Records come from the Team endpoints of this app's REST API (avo-api), and the resource builds the write requests itself."
  self.visible_on_sidebar = false
  self.http_adapter = {
    endpoint: Rails.env.production? ? "https://main.avodemo.com/api/resources/v1/teams" : "http://localhost:3020/api/resources/v1/teams",
    # An API caller's own bearer token is passed on; the panel has none, so it sends the cookie's.
    headers: -> {
      {"Authorization" => request.authorization.presence || "Bearer #{request.cookies["avo_api_token"]}"}
    },
    parse_collection: -> {
      raise Avo::HttpError.new response["error"] if response["error"].present?

      response["records"]
    },
    parse_record: -> {
      raise Avo::HttpError.new response["error"] if response["error"].present?

      response["record"]
    },
    # The model only gains an accessor once a response carries the attribute, and the list has no url.
    model_class_eval: -> { attr_accessor :url },
    parse_count: -> { response.dig("pagination", "total_count") }
  }

  # The API wants the attributes nested under `team`, and the default client sends them flat.
  def save_record(record)
    request = {body: {team: {name: record.name, url: record.try(:url)}}, headers: request_headers, timeout: 10}
    response = if view.create?
      HTTParty.post(self.class.endpoint, request)
    else
      HTTParty.patch("#{self.class.endpoint}/#{record.id}", request)
    end

    record.id = response.dig("record", "id") if response.success?
    add_api_errors(record, response)
  end

  def destroy_record(record) = add_api_errors(record, client.delete(record.id))

  def fields
    field :id, as: :id
    field :name, as: :text, required: true
    field :url, as: :text
  end

  private

  def request_headers = Avo::ExecutionContext.new(target: self.class.headers).handle

  # Without this a refused write fails with no reason: the caller only sees that it failed.
  def add_api_errors(record, response)
    return true if response.success?

    errors = response.parsed_response.try(:[], "errors").presence || {base: "The API responded with #{response.code}."}
    errors.each { |attribute, messages| Array.wrap(messages).each { record.errors.add(attribute, _1) } }
    false
  end
end
