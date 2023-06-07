class Avo::Resources::Comment < Avo::BaseResource
  self.title = :tiny_name
  self.includes = []
  self.description = "Demo resource to illustrate Avo's Polymorphic BelongsTo support (Comment is commentable to Post and Project)"
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], body_cont: params[:q], m: "or").result(distinct: false)
    end
  }

  def fields
    field :id, as: :id
    field :body, as: :textarea
    field :excerpt, as: :text, show_on: :index, as_description: true do
      ActionView::Base.full_sanitizer.sanitize(record.body).truncate 60
    rescue
      ""
    end

    field :user, as: :belongs_to
    field :commentable, as: :belongs_to, polymorphic_as: :commentable, types: [::Post, ::Project]
  end
end
