class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :reset

  def hey
    render plain: 'hey back'
  end

  def reset
    ReSeedJob.perform_later

    render plain: 'ok'
  end
end
