class Avo::Resources::HttpUser < Avo::Core::Resources::Http
  self.icon = "heroicons/outline/cloud"
  self.http_adapter = {
    endpoint: Rails.env.production? ? "https://main.avodemo.com/api/resources/v1/users" : "http://localhost:3020/api/resources/v1/users",
    # Bearer token example -- the only credential this API accepts, now that
    # BaseResourcesController inherits avo-api's own `setup_authentication`.
    # Read from the cookie the Settings → Integrations form sets; mint the token
    # itself in Avo API Tokens. No default: a token secret is shown once, at
    # creation, so there is nothing to fall back to. Without one the API answers
    # 401 and `parse_collection` below turns that into a clean "Unauthorized".
    headers: -> {
      {
        "Authorization" => "Bearer #{request.cookies["avo_api_token"]}"
      }
    },
    parse_collection: -> {
      if raw_response.code == 401
        raise Avo::HttpError.new "Unauthorized"
      end

      raise Avo::HttpError.new response["message"] if response["error"].present?

      response["records"]
    },
    parse_record: -> {
      response["record"]
    },
    parse_count: -> {
      response["pagination"]&.dig("total_count")
    }
  }
  self.description = -> { "This is a HttpResource (avo-http_resource) to the Avo::Resources::User endpoints (avo-api) running at #{view_context.link_to(resource.http_adapter[:endpoint], resource.http_adapter[:endpoint], target: "_blank")}".html_safe }
  self.visible_on_sidebar = false

  def fields
    field :first_name
    field :last_name
    field :email
    field :created_at
    field :updated_at
  end
end
