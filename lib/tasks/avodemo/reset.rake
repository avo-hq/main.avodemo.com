namespace :avodemo do
  desc "Reset the demo instance"

  task :reset => [ :environment ]  do
    ReSeedJob.perform_now
  end
end