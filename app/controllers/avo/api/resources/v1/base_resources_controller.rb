module Avo
  module Api
    module Resources
      module V1
        class BaseResourcesController < ResourcesController
          # This app uses Pundit authorization for the Avo UI, but the public API
          # (like the ref demo) is unauthenticated/unauthorized — and the Avo
          # authorization redirect-on-failure targets `avo/home`, which doesn't
          # exist inside the API engine. Skip Avo authorization for API requests.
          skip_before_action :authorize_base_action, raise: false

          def setup_authentication
            # disable authentication for now
            return true

            raise Avo::Api::AuthenticationError unless authenticate_with_http_basic do |email, password|
              user = User.find_by(email: email)

              if user&.valid_password?(password)
                sign_in(user, store: false)
              else
                false
              end
            end
          end
        end
      end
    end
  end
end
