class Avo::Forms::Settings::Integrations < Avo::Forms::Core::Form
  self.title = "API Integrations"
  self.description = "Manage your API integrations"

  def fields
    card do
      field :email_and_password, as: :text, format_using: -> {
        request.cookies["email_password"] || "avo@avohq.io:secret"
      }, help: "This is the email and password that the Http Users resource uses to access the Avo API. Use avo@avohq.io:secret for authorized access."
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
    cookies["email_password"] = params[:email_and_password]
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
