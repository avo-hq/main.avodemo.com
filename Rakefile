# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

Rake::Task["assets:precompile"].enhance do
  Rake::Task["db:migrate"].execute
end
Rake::Task["db:migrate"].enhance do
  Rake::Task["avo:install"].execute
end

task 'avo:install' do
  enabled = Rails.env.staging?
  enabled = true

  if enabled
    puts "Starting avo:install"
    path = locate_gem 'avo'

    # system "sh scripts/avo_install.sh #{path}"
    Dir.chdir(path) do
      system 'yarn'
      system 'yarn build:prod'
    end

    puts "Done"
  else
    puts "Not starting avo:install"
  end
end

# From
# https://stackoverflow.com/questions/9322078/programmatically-determine-gems-path-using-bundler
def locate_gem(name)
  spec = Bundler.load.specs.find{|s| s.name == name }
  raise GemNotFound, "Could not find gem '#{name}' in the current bundle." unless spec
  if spec.name == 'bundler'
    return File.expand_path('../../../', __FILE__)
  end
  spec.full_gem_path
end

