class Avo::Actions::ToggleActive < Avo::BaseAction
  self.name ='Toggle active'

  def fields
    field :notify_user, as: :boolean
    field :message, as: :textarea, default: 'Your account has been marked as inactive.'
  end

  def handle(records:, fields:, current_user:, resource:)
    records.each do
      if record.active
        record.update active: false
      else
        record.update active: true
      end

      record.notify fields['message'] if fields['notify_user']
    end

    succeed 'Perfect!'
  end
end
