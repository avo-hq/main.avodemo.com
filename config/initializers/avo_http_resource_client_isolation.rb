# Fix cross-resource base_uri collision in avo-http_resource.
#
# All HTTP resources (Avo::Resources::Author, Avo::Resources::HttpUser, ...) share a
# single `Avo::HttpResource::Client` class, and HTTParty stores `base_uri` at the
# CLASS level. So whichever resource's client is instantiated last wins globally —
# e.g. rendering the sidebar's API section builds the Author client, leaving
# base_uri = "https://api.openalex.org/authors". A subsequent HttpUser request to
# localhost then trips HTTParty's cross-host safety check:
#
#   HTTParty::UnsafeURIError: Requested URI 'http://localhost:3000/...users' has host
#   'localhost' but the configured base_uri 'https://api.openalex.org/authors' has
#   host 'api.openalex.org'.
#
# Each client instance already knows its own endpoint (@endpoint). Re-assert that
# endpoint as the class base_uri right before every request, so a sibling client
# built in the same Rails request can't leave a stale base_uri behind. Requests are
# synchronous within a Rails request thread, so this is race-free in practice.
Rails.application.config.to_prepare do
  if defined?(Avo::HttpResource::Client)
    guard = Module.new do
      [:all, :find, :create, :update, :delete].each do |method_name|
        define_method(method_name) do |*args, **kwargs, &block|
          self.class.base_uri(@endpoint) if defined?(@endpoint) && @endpoint
          super(*args, **kwargs, &block)
        end
      end
    end

    unless Avo::HttpResource::Client.ancestors.any? { |m| m.to_s.include?("AvoHttpResourceClientBaseUriGuard") }
      Avo::HttpResource.const_set(:AvoHttpResourceClientBaseUriGuard, guard)
      Avo::HttpResource::Client.prepend(guard)
    end
  end
end
