# Crystal [ANN]
[![Build Status](https://travis-ci.org/veelenga/crystal-ann.svg?branch=master)](https://travis-ci.org/veelenga/crystal-ann)
[![Amber Framework](https://img.shields.io/badge/using-amber%20framework-orange.svg)](https://github.com/veelenga/crystal-ann)
[![Gitter](https://badges.gitter.im/veelenga/crystal-ann.svg)](https://gitter.im/veelenga/crystal-ann?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Source code for https://crystal-ann.com.

## Develop

Create a pg database called `crystal_ann`. Then:

```
$ shards update
$ amber migrate up
$ crystal db/seed.cr
$ amber watch
```

## Test

Create a pg database called `crystal_ann_test`. Then:

```
$ MICRATE_RUN_UP=true crystal spec
```

## Deployment to Heroku

```
$ heroku create app-name --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal.git
$ heroku buildpacks:add https://github.com/veelenga/heroku-buildpack-sidekiq.cr
$ git push heroku master
```

And set environment variables with `heroku config:set VAR=VAL`:

```
AMBER_ENV
AMBER_SESSION_SECRET

MICRATE_RUN_UP
REDIS_PROVIDER

GITHUB_ID
GITHUB_SECRET

TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET
TWITTER_ACCESS_TOKEN
TWITTER_ACCESS_TOKEN_SECRET
```
