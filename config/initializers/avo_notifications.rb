Avo::Notifications.configure do |config|
  # How long notifications are kept before cleanup. Default: 30 days.
  # Expired notifications are removed when you run:
  #   bin/rails avo_notifications:cleanup
  # Schedule this via cron (e.g., daily).
  # config.ttl = 30.days

  # Enable/disable real-time Turbo Stream delivery via ActionCable. Default: true.
  # Set to false if ActionCable is not configured in your app.
  # config.realtime = true

  # Number of notifications shown in the bell dropdown. Default: 10.
  # config.dropdown_limit = 10

  # The model class that represents the current Avo user.
  # Used for the polymorphic recipient association.
  # config.user_class = "User"

  # The method on the user model that returns the display name.
  # Used for sender attribution on notifications.
  # Falls back to :email, then :to_s if the method doesn't exist.
  # config.user_display_name_method = :name
end
