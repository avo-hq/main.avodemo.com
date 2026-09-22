module Avo
  module Api
    module Resources
      module V1
        class BaseResourcesController < ResourcesController
          # This app uses Pundit authorization for the Avo UI, and the Avo
          # authorization redirect-on-failure targets `avo/home`, which doesn't
          # exist inside the API engine. Skip Avo authorization for API requests.
          skip_before_action :authorize_base_action, raise: false

          # There is deliberately no `setup_authentication` here.
          #
          # avo-api's own implementation is the whole gate: a bearer token, or a
          # 401. Every override this app has ever had made it weaker -- it opened
          # with `return true` ("disable authentication for now") above a block of
          # HTTP Basic code that therefore never ran, which left every endpoint on
          # a public host answering anyone, DELETE included. A later version
          # accepted HTTP Basic beside the token, which meant this app maintained
          # a second credential path in front of an API mounted outside the Devise
          # `authenticate` block.
          #
          # Inheriting means there is nothing here to get wrong, and the demo
          # exercises exactly what a customer's app gets out of the box. It also
          # means every request now carries a token, so `Avo::Api::Current.token`
          # is set and the schema endpoint's entitlements describe that token
          # rather than falling through its no-token branch.
          #
          # Anything pointed at this API needs a token minted in **Avo API
          # Tokens** -- the Http Users resource included, which reads one from the
          # cookie the Settings → Integrations form sets.
        end
      end
    end
  end
end
