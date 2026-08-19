# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/4.0/controllers.html
class Avo::HttpUsersController < Avo::Core::Controllers::Http
  def save_record
    response = api_response
    payload = response.parsed_response
    payload = {} unless payload.is_a?(Hash)

    if payload["record"].present?
      @record.id = payload["record"]["id"]
      return true
    end

    if payload["errors"].present?
      payload["errors"].each do |attribute, messages|
        Array.wrap(messages).each { |message| @record.errors.add(attribute, message) }
      end
    else
      # 401/404/5xx carry no `errors` payload — without this the form would fail
      # silently, or blow up iterating nil.
      @record.errors.add(:base, "The API responded with #{response.code}.")
    end

    false
  end

  def create_success_action
    redirect_to avo.resources_http_user_path(@record)
  end

  private

  # The API nests the payload under `user` and needs a password on create, so the
  # request is built here instead of going through the client's create/update.
  #
  # It must request the resource's own (absolute) endpoint: a relative path has no
  # host to connect to, and Net::HTTP fails on the nil address well after the form
  # was submitted (AVO-1745).
  def api_response
    endpoint = resource.endpoint
    headers = Avo::ExecutionContext.new(target: resource.headers).handle

    if action_name == "create"
      body = {user: @record.as_json.merge(password: SecureRandom.hex(10))}

      HTTParty.post(endpoint, body: body, headers: headers)
    else
      HTTParty.patch("#{endpoint}/#{@record.id}", body: {user: @record.as_json}, headers: headers)
    end
  end
end
