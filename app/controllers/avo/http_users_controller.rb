# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/4.0/controllers.html
class Avo::HttpUsersController < Avo::Core::Controllers::Http
  def save_record
    if action_name == "create"
      response = resource.client.class.post("", body: {user: @record.as_json.merge(password: SecureRandom.hex(10))})
    else
      response = resource.client.class.patch("/#{@record.id}", body: {user: @record.as_json.merge(password: SecureRandom.hex(10))})
    end

    parsed_response = response.parsed_response

    if parsed_response["record"].present?
      @record.id = parsed_response["record"]["id"]
      return true
    else
      parsed_response["errors"].each do |attribute, message|
        message.each do |error|
          @record.errors.add(attribute, error)
        end
      end
      return false
    end
  end

  def create_success_action
    redirect_to avo.resources_http_user_path(@record)
  end
end
