class Avo::Actions::TogglePublished < Avo::BaseAction
  self.name = 'Toggle post published'
  self.message = 'Are you sure, sure?'
  self.confirm_button_label = 'Toggle'
  self.cancel_button_label = "Don't toggle yet"
  # Avo 4: honor a `confirmation: false` argument (e.g. from the Post resource's
  # discreet_information toggle link) to skip the confirmation modal. Replaces the
  # Avo 3 `no_confirmation` argument pattern.
  self.confirmation = -> { arguments.key?(:confirmation) ? arguments[:confirmation] : true }

  def handle(records:, fields:, current_user:, resource:, **)
    records.each do |record|
      if record.published_at.present?
        record.update published_at: nil
      else
        record.update published_at: DateTime.now
      end
    end

    succeed 'Perfect!'
  end
end
