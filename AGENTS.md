# Avo

1. When working with Avo, use https://docs.avohq.io/4.0/docs-map.md to find and read the relevant documentation. Match examples to the versions in `Gemfile.lock`.
2. Load `.agents/skills/avo/SKILL.md` for Avo work, including Rails model changes that may need matching admin changes. It resolves the official skills from this app's installed gems; do not copy the skill catalog into this repository.

# `lc` branch: Laravel Cloud test deploy

`lc` is `main` plus a few commits for deploying to Laravel Cloud. It lives on `origin` as `lc`. Laravel Cloud deploys from it. Don't mention it on `main`, issues or PRs.

## What differs from `main`

- `config/puma.rb`: binds `tcp://[::]:$PORT` instead of `port`. Laravel Cloud is IPv6-only and can't reach `0.0.0.0`.
- `config/puma.rb`: `plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]`. Laravel Cloud has no worker process, so jobs run inside Puma.
- `config/database.yml`: production `primary` reads `DATABASE_URL` instead of `main`'s `RED_DATABASE_URL`.
- `bin/jobs`: defaults `RAILS_LOG_TO_STDOUT` to `1`, so job logs show up in Laravel Cloud.
- This file.

Laravel Cloud setup (in the dashboard, not the repo):

- Env var `BUNDLE_PACKAGER__DEV=<token>`.
- Env var `SOLID_QUEUE_IN_PUMA=1`.

## Keeping `lc` in sync

Merge, don't rebase, so the branch never needs a force-push.

```sh
git switch main && git pull
git switch lc
git merge main
git push origin lc
```

Conflicts:

- `config/puma.rb`: keep the `bind "tcp://[::]:..."` line and the `solid_queue` plugin line.
- `config/database.yml`: keep `DATABASE_URL` in production `primary`.
- `Gemfile.lock`: take `main`'s version, then run `bundle install`.

Check after merging:

```sh
bundle install
bin/rails runner 'p Avo::Dashboards'
```

Never merge `lc` into `main`.
