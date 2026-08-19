Flightdeck.configure do |config|
  # Reuse the app's own Devise + admin check rather than Flightdeck's HTTP Basic.
  # A String on purpose — the class is resolved lazily so this does not force the
  # controller to autoload at boot.
  config.base_controller_class = "FlightdeckBaseController"

  # The demo app's records are seeded in UTC and the AI chat timestamps render in
  # the reader's zone; keep the job dashboard on UTC so the two don't disagree.
  config.display_timezone = "UTC"
end
