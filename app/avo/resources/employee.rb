class Avo::Resources::Employee < Avo::BaseResource
  self.icon = "heroicons/outline/identification"
  self.title = :name
  self.description = "Field authorization demo. EmployeePolicy withholds Performance rating (not on its allowlist) " \
    "and SSN (on its denylist) everywhere, and Salary from the REST API, the AI chat and MCP while the panel still shows it."
  self.search = {
    query: -> { query.ransack(name_cont: params[:q], email_cont: params[:q], m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text, required: true
    field :email, as: :text
    field :department, as: :select, options: %w[Engineering Sales Support Finance].index_by(&:itself)
    field :salary, as: :number, help: "Withheld from the REST API, the AI chat and MCP."
    field :ssn, as: :text, name: "SSN", help: "Withheld everywhere: on the policy's denylist."
    field :performance_rating, as: :number, help: "Withheld everywhere: not on the policy's allowlist."
    field :hired_on, as: :date
    field :notes, as: :textarea
    field :created_at, as: :date_time, only_on: :index
  end
end
