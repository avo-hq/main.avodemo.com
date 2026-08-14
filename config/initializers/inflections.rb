# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

# app/policies/avo/ai/* must define Avo::AI::* (avo-ai model class names) so the
# gem's policy lookup finds them. Segment-scoped on purpose: a global
# `inflect.acronym "AI"` would rewrite every "ai" path segment app-wide.
Rails.autoloaders.each { |autoloader| autoloader.inflector.inflect("ai" => "AI") }
