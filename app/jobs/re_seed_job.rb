class ReSeedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SeedService.seed
  end
end
