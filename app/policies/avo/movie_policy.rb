# Movie's model (Avo::Movie) is not ActiveRecord-backed, so the BaseAvoPolicy::Scope
# falls back to returning the scope unchanged.
class Avo::MoviePolicy < BaseAvoPolicy
end
