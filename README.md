# README

### Visit the live app on [main.avodemo.com](https://main.avodemo.com/)

This is a demo app to show how simple it is to integrate [Avo](https://avohq.io) in your app.

Have a look at the [/avo](/app/avo) directory to find the resources, filters and actions.

### Install locally

This should be a pretty straightforward Rails install. The app has seeds and everything it needs.

```bash
bundle install

bin/rails db:setup
```

To start the server either use:

```bash
rails assets:precompile

bin/rails server
```

or uncomment the `css: rails tailwindcss:watch` in the `Procfile.dev`-file and start the server via the dev-script:

```bash
bin/dev
```
