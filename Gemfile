source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", ">= 8.1"
# gem "rails", github: "rails/rails", branch: "main"
# gem "activestorage", github: "rails/rails", branch: "main"
# gem "actionmailer", github: "rails/rails", branch: "main"
# gem "actioncable", github: "rails/rails", branch: "main"

gem "propshaft"

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # require: false avoids loading pp → prettyprint during Bundler.require; a broken Ruby default-gem
  # tree for prettyprint then cannot crash boot. Use `require "debug/start"` or `bin/rdbg` when debugging.
  gem "debug", platforms: %i[ mri windows ], require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "annotate"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# authentication
gem 'devise'

gem 'factory_bot_rails'
gem 'faker'

# File storage S3
gem 'aws-sdk-s3', require: false

gem 'dotenv-rails', groups: [ :development, :test ]

gem "awesome_print"

# NOTE: pin Avo 4 beta gems to EXACT versions. `>=` is unsafe here because the
# `4.0.0.pre.dev.*` dev builds sort HIGHER than `4.0.0.beta.*` in RubyGems
# version ordering ("pre" > "beta"), so a `>=` constraint resolves to a broken
# dev build that fails to boot. Bump these explicitly when upgrading betas.
gem "avo"

source "https://packager.dev/avo-hq/" do
  gem "avo-dashboards"
  gem "avo-menu"
  gem "avo-advanced_search"
  gem "avo-authorization"
  gem "avo-record_reordering"
  gem "avo-scopes"
  gem "avo-custom_controls"
  gem "avo-dynamic_filters"
  gem "avo-nested"
  gem "avo-api"
  gem "avo-http_resource"
  gem "avo-collaboration"
  gem "avo-forms"
  gem "avo-reactive_fields"
  gem "avo-kanban"
end

# avo-nested is no longer bundled inside avo-advanced in Avo 4; this app uses
# nested association forms (see app/views/avo/resource_tools/_nested_fish_reviews.html.erb).

# Kanban boards for Avo. Pin to an EXACT version for the same reason as the
# other Avo 4 beta gems above (pre.dev builds sort higher than beta).

# Avo 4 suite gems for the new feature demos (REST API, HTTP resources,
# collaboration, reactive fields, forms). EXACT pins (see note above) — these are
# the versions that resolve against avo 4.0.0.beta.42. Bump explicitly on upgrade.

# Backs the Avo::Forms::Settings::Integrations demo form (DB-stored config values).
gem "db_config", "0.1.10"

# view_component 4.0.0 caps activesupport < 8.1, conflicting with rails 8.1.3.
# Bumped to 4.11.0 (no activesupport cap; the version avo-4.avodemo.com runs).
# avo .42 only requires view_component >= 3.7.0.
gem "view_component"

gem "avo-rhino_field", "4.0.0"

# gem "avo", path: "/Users/adrian/work/avocado/gems/avo"
# gem "avo", path: "../gems/avo"
# gem "avo", ">= 3.6.3", github: "avo-hq/avo", branch: "fix/table_cache"

# gem 'newrelic_rpm'

gem 'ransack'

gem 'bugsnag'

gem "tailwindcss-rails", "~> 2.7"

gem "mini_magick"

gem "appsignal"

gem "acts_as_list"

gem 'friendly_id', '~> 5.4.0'
gem "prefixed_ids", "~> 1.6", ">= 1.6.1"
gem "hashid-rails", "~> 1.4", ">= 1.4.1"

gem "acts-as-taggable-on", ">= 13.0.0"

gem 'pundit'
gem 'chartkick'
gem 'countries'
gem 'mapkick-rb'

gem "dockerfile-rails", ">= 1.3", :group => :development

gem "whenever"

gem "pagy"

gem "avo-money_field"
gem "money-rails", "~> 1.12"

gem "redcarpet"
gem "marksmith"
gem "commonmarker"
