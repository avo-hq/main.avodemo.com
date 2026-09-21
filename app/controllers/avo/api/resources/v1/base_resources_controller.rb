module Avo
  module Api
    module Resources
      module V1
        class BaseResourcesController < ResourcesController
          # This app uses Pundit authorization for the Avo UI, and the Avo
          # authorization redirect-on-failure targets `avo/home`, which doesn't
          # exist inside the API engine. Skip Avo authorization for API requests.
          skip_before_action :authorize_base_action, raise: false

          # Two credentials reach this API, and both are real traffic:
          #
          #   * a **bearer token** -- avo-api's own scheme, and what any API
          #     client sends (avo-cli among them). `super` accepts it.
          #   * **HTTP Basic** -- what the Http Users resource on this very app
          #     sends (see Avo::Resources::HttpUser), demoing avo-http_resource
          #     against these endpoints. Its credential is the one the Settings
          #     → Integrations form shows.
          #
          # Anything else is refused with a 401.
          #
          # This used to `return true` ahead of both -- "disable authentication
          # for now" -- which left every endpoint on a public host open to the
          # internet, DELETE included. The dead HTTP Basic block underneath it
          # never ran, while the mount comment in `config/routes.rb` went on
          # saying the API carried its own auth.
          #
          # The header is read directly rather than through avo-api's own
          # `bearer_credential`, which is private to the gem's controller: this
          # app tracks a `.dev` build of avo-api, and a private helper is not
          # something to pin a public endpoint's auth to.
          def setup_authentication
            return super if request.authorization.to_s.start_with?("Bearer ")

            raise Avo::Api::AuthenticationError unless authenticate_with_http_basic do |email, password|
              user = User.find_by(email: email)

              if user&.valid_password?(password)
                sign_in(user, store: false)

                # Explicit, rather than leaning on whatever `sign_in` returns:
                # this block's value is the whole verdict.
                true
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
