# Authentication gate for the Solid Queue dashboard (config/initializers/flightdeck.rb
# points Flightdeck at this class). Flightdeck can retry, discard and delete jobs, and
# it does not inspect routes — without a base controller it answers 401 even behind the
# `authenticate :user` constraint in routes.rb. ApplicationController is bare, so the
# checks live here.
class FlightdeckBaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    head :forbidden unless current_user&.admin?
  end
end
