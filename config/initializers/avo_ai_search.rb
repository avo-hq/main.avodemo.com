# avo-ai's resources ship without self.search, so global search skips them.
# Patch it on here until the gem provides its own.
Rails.application.config.to_prepare do
  # The gem's models don't inherit from this app's ApplicationRecord, so they
  # lack a ransack allowlist and ransack raises. Allow all columns, same as
  # app/models/application_record.rb does.
  Avo::AI::ApplicationRecord.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      authorizable_ransackable_attributes
    end
  end

  Avo::Resources::AvoAi::Chat.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false) }
  }
  Avo::Resources::AvoAi::Message.search = {
    query: -> { query.ransack(id_eq: params[:q], content_cont: params[:q], m: "or").result(distinct: false) }
  }
  Avo::Resources::AvoAi::Model.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], model_id_cont: params[:q], provider_cont: params[:q], m: "or").result(distinct: false) }
  }
  Avo::Resources::AvoAi::ToolCall.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false) }
  }
end
