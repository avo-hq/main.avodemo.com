# Solid Queue runs as its own process, not the Puma plugin, so the queue only
# drains while `worker` is up. Hatchbox picks the worker process up from this
# file; confirm it is actually running after the first deploy that adds it —
# if it isn't, jobs enqueue silently and nothing processes them.
web: bundle exec puma -C config/puma.rb
worker: bin/jobs
