source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", ">= 7.2.0.beta2"
gem "activestorage"
gem "actionmailer"
gem "actioncable"
# gem "rails", github: "rails/rails", branch: "main"
# gem "activestorage", github: "rails/rails", branch: "main"
# gem "actionmailer", github: "rails/rails", branch: "main"
# gem "actioncable", github: "rails/rails", branch: "main"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

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
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
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

gem "avo-advanced", "3.24.1", source: "https://packager.dev/avo-hq/"
gem "avo-http_resource", source: "https://packager.dev/avo-hq/"
gem "avo", "3.24.1"

gem "view_component", "4.0.0"

gem "avo-rhino_field", "0.0.16"

# gem "avo", path: "/Users/adrian/work/avocado/gems/avo"
# gem "avo", path: "../gems/avo"
# gem "avo", ">= 3.6.3", github: "avo-hq/avo", branch: "fix/table_cache"

# gem 'newrelic_rpm'

gem 'ransack'

gem 'bugsnag'

gem "tailwindcss-rails", "~> 2.0"

gem "mini_magick"

gem "appsignal"

gem "acts_as_list"

gem 'friendly_id', '~> 5.4.0'
gem "prefixed_ids", "~> 1.6", ">= 1.6.1"
gem "hashid-rails", "~> 1.4", ">= 1.4.1"

# gem 'acts-as-taggable-on', '>= 10'
gem "acts-as-taggable-on", github: "avo-hq/acts-as-taggable-on"

gem 'pundit'
gem 'chartkick'
gem 'countries'
gem 'sprockets'
gem 'mapkick-rb'

gem "dockerfile-rails", ">= 1.3", :group => :development

gem "whenever"

gem "pagy"

gem "avo-money_field"
gem "money-rails", "~> 1.12"

gem "redcarpet"
gem "marksmith"
gem "commonmarker"
