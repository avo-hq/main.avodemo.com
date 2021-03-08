module Avo
  module Resources
    class Project < Resource
      def configure
        @title = :name
        @search = [:name, :id]
        @includes = :users
      end

      def fields(request)
        f.id link_to_resource: true
        f.text :name, required: true, link_to_resource: true
        f.status :status, failed_when: [:closed, :rejected, :failed], loading_when: [:loading, :running, :waiting], nullable: true
        f.select :stage, hide_on: [:show, :index], options: { discovery: 'Discovery', ideea: 'Ideea', done: 'Done', 'on hold': 'On hold', cancelled: 'Cancelled' }, placeholder: 'Choose the stage.'
        f.badge :stage, options: { info: [:discovery, :ideea], success: :done, warning: 'on hold', danger: :cancelled }
        f.markdown :description, height: '350px'
        # f.currency :budget, currency: 'EUR', locale: 'de-DE'
        f.country :country
        f.number :users_required
        f.date_time :started_at, time_24hr: true
        f.files :files
        # f.key_value :meta, key_label: 'Meta key', value_label: 'Meta value', action_text: 'New item', delete_text: 'Remove item', disable_editing_keys: false, disable_adding_rows: false, disable_deleting_rows: false

        f.has_and_belongs_to_many :users
      end
    end
  end
end
