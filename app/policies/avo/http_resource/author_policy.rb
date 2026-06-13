# Authorizes the Author HTTP resource (avo-http_resource). Its model class is the
# dynamically-defined Avo::HttpResource::Author, so Pundit resolves the policy here.
class Avo::HttpResource::AuthorPolicy < BaseAvoPolicy
end
