# frozen_string_literal: true

class HealthController < ActionController::Base
  rescue_from(Exception) { render_down }

  def show
    # check db connection
    # User.count

    # check redis connection
    # r = Redis.new
    # r.ping

    render_up
  end

  private

  def render_up
    render html: html_status(color: "green")
  end

  def render_down
    render html: html_status(color: "red"), status: 500
  end

  def html_status(color:)
    %(<html><body style="background-color: #{color}"></body></html>).html_safe
  end
end
