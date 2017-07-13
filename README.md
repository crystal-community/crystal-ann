# Crystal [ANN]

Source code for https://crystal-ann.com.

## Setup

Create a pg database called `crystal_ann` and configure the `config/database.yml`
to provide the credentials to access the table.

Then:
```
$ shards update
$ amber migrate up
$ crystal db/seed.cr
```

## Run

```
$ amber watch
```

## Deployment to Heroku

```
$ heroku create app-name --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal.git
$ heroku buildpacks:add https://github.com/veelenga/heroku-buildpack-sidekiq.cr
$ git push heroku master
```

And set environment variables:

```
$ heroku config:set AMBER_ENV=production
$ heroku config:set GITHUB_ID=github_client_id
$ heroku config:set GITHUB_SECRET=github_client_secret
$ heroku config:set TWITTER_CONSUMER_KEY=twitter_consumer_key
$ heroku config:set TWITTER_CONSUMER_SECRET=twitter_consumer_secret
$ heroku config:set TWITTER_ACCESS_TOKEN=twitter_access_token
$ heroku config:set TWITTER_ACCESS_TOKEN_SECRET=twitter_access_token_secret
```
