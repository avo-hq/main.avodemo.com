class Avo::Actions::ToggleActive < Avo::BaseAction
  self.name ='Toggle active'

  def fields
    field :notify_user, as: :boolean
    field :message, as: :textarea, default: 'Your account has been marked as inactive.'
  end

  def handle(models:, fields:, current_user:, resource:)
    models.each do |model|
      if model.active
        model.update active: false
      else
        model.update active: true
      end

      model.notify fields['message'] if fields['notify_user']
    end

    succeed 'Perfect!'
  end
end