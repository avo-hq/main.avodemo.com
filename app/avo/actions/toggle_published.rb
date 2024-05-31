class Avo::Actions::TogglePublished < Avo::BaseAction
  self.name = 'Toggle post published'
  self.message = 'Are you sure, sure?'
  self.confirm_button_label = 'Toggle'
  self.cancel_button_label = "Don't toggle yet"

  def handle(records:, fields:, current_user:, resource:, **)
    records.each do
      if record.published_at.present?
        record.update published_at: nil
      else
        record.update published_at: DateTime.now
      end
    end

    succeed 'Perfect!'
  end
end
