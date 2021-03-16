class UserResource < Avo::BaseResource
  self.title = :name
  self.search = [:id, :first_name, :last_name]
  self.includes = :posts
  self.devise_password_optional = true

  fields do |f|
    f.id link_to_resource: true
    f.gravatar :email, link_to_resource: true
    f.heading 'User information'
    f.text :first_name, required: true, placeholder: 'John'
    f.text :last_name, required: true, placeholder: 'Doe'
    f.text :email, name: 'User Email', required: true
    f.boolean :active, name: 'Is active', show_on: :show
    f.file :cv, name: 'CV'
    f.boolean :is_admin?, name: 'Is admin', only_on: :index
    f.boolean_group :roles, options: { admin: 'Administrator', manager: 'Manager', editor: 'Editor', writer: 'Writer' }
    f.date :birthday, first_day_of_week: 1, picker_format: 'F J Y', format: '%Y-%m-%d', placeholder: 'Feb 24th 1955', required: true
    f.text :is_writer, format_using: -> (value) { value.truncate 3 }, hide_on: :edit do |model, resource, view, field|
      model.posts.to_a.count > 0 ? 'yes' : 'no'
    end
    f.code :custom_css, theme: 'dracula', language: 'css', help: "This enables you to edit the user's custom styles.", height: '250px'

    f.password :password, name: 'User Password', required: true, except_on: :forms, help: 'You may verify the password strength <a href="http://www.passwordmeter.com/">here</a>.'
    f.password :password_confirmation, name: 'Password confirmation', required: false

    f.hidden :team_id, default: 0 # For testing purposes

    f.has_and_belongs_to_many :projects
    f.has_many :posts
  end

  grid do |cover, title, body|
    cover.gravatar :email, link_to_resource: true
    title.text :name, link_to_resource: true
    body.text :url
  end

  actions do |a|
    a.use ToggleInactive
  end
end