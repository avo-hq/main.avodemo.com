class Avo::Forms::Settings::Integrations < Avo::Forms::Core::Form
  self.title = "API Integrations"
  self.description = "Manage your API integrations"

  def fields
    card do
      field :api_token, as: :text, format_using: -> {
        request.cookies["avo_api_token"]
      }, help: "Bearer token the Http Users resource sends to the Avo API. Mint one under Avo API Tokens and paste it here — the secret is only shown once, at creation, so there is no default to fall back to."
    end

    # USE CASE FOR THIS PANEL:
    # - Search for a key
    # - If the key is not found, set a default value and save it to the database
    card title: "DBConfig", description: "Test section using db_config gem" do
      field :eager_load, as: :boolean, format_using: -> { DBConfig.fetch(:eager_load) { false } }
      field :api_key, as: :text, format_using: -> { DBConfig.fetch(:api_key) { "random_api_key" } }
      field :password, as: :password, revealable: true, format_using: -> { DBConfig.fetch(:password) { "random_password" } }
      field :code, as: :code, format_using: -> { JSON.pretty_generate(DBConfig.fetch(:code) { {random: "random_code"} }) }
      field :boolean, as: :boolean, format_using: -> { DBConfig.fetch(:boolean) { true } }
      field :number, as: :number, format_using: -> { DBConfig.fetch(:number) { 31 } }
    end
  end

  def handle
    flash[:success] = "Awesome!"
    cookies["avo_api_token"] = params[:api_token]
    eager_load = ActiveModel::Type::Boolean.new.cast(params[:eager_load])

    # Params here are all strings, so we need to convert them to the correct type when updating the DBConfig
    DBConfig.update(:api_key, value: params[:api_key], eager_load:)
    DBConfig.update(:password, value: params[:password], eager_load:)
    DBConfig.update(:code, value: params[:code], eager_load:, type: "Hash")
    DBConfig.update(:boolean, value: params[:boolean], eager_load:, type: "Boolean")
    DBConfig.update(:number, value: params[:number], eager_load:, type: "Integer")
    DBConfig.update(:eager_load, value: eager_load, eager_load:)

    default_response
  end
end
