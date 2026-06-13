class Avo::Resources::HttpUser < Avo::Core::Resources::Http
  self.http_adapter = {
    endpoint: Rails.env.production? ? "https://main.avodemo.com/api/resources/v1/users" : "http://localhost:3020/api/resources/v1/users",
    # Basic auth example. The credential is read from a cookie set by the
    # Settings → Integrations form (defaults to avo@avohq.io:secret).
    headers: -> {
      {
        "Authorization" => "Basic #{Base64.encode64(request.cookies["email_password"] || "avo@avohq.io:secret")}".gsub("\n", "")
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
