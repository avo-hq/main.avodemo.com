# `lc` branch: Laravel Cloud test deploy

`lc` is `main` plus a few commits for deploying to Laravel Cloud. It lives on `origin` as `lc`. Laravel Cloud deploys from it. Don't mention it on `main`, issues or PRs.

## What differs from `main`

- `Gemfile`: the `packager.dev` block sits inside `group :private_gems, optional: true`. Laravel Cloud's gem install step gets no env vars, so it can't authenticate to packager.dev.
- `config/application.rb`: `Bundler.require(*Rails.groups, :private_gems)`. Optional groups are not auto-required.
- `config/puma.rb`: binds `tcp://[::]:$PORT` instead of `port`. Laravel Cloud is IPv6-only and can't reach `0.0.0.0`.
- `bin/jobs`: defaults `RAILS_LOG_TO_STDOUT` to `1`, so job logs show up in Laravel Cloud.
- `config/initializers/avo.rb`: `exclude_from_status = []`, so the Avo debug page shows the license key.
- This file.

Laravel Cloud setup (in the dashboard, not the repo):

- Env var `BUNDLE_PACKAGER__DEV=<token>`. Do not set `BUNDLE_WITH`.
- Build commands start with:

  ```sh
  bundle config set --local with private_gems
  bundle install
  ```

Locally, run `bundle config set --local with private_gems` once.

## Keeping `lc` in sync

Merge, don't rebase, so the branch never needs a force-push.

```sh
git switch main && git pull
git switch lc
git merge main
git push origin lc
```

Conflicts:

- `Gemfile`: keep `main`'s gem list. Make sure every `packager.dev` gem stays inside the `private_gems` group, including gems `main` just added.
- `config/application.rb`: keep `main`'s changes. Keep `:private_gems` in the `Bundler.require` call.
- `config/puma.rb`: keep the `bind "tcp://[::]:..."` line.
- `Gemfile.lock`: take `main`'s version, then run `bundle install`.

Check after merging:

```sh
bundle install
bin/rails runner 'p Avo::Dashboards'
```

Never merge `lc` into `main`.
