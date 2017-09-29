# Crystal [ANN]
[![Build Status](https://travis-ci.org/crystal-community/crystal-ann.svg?branch=master)](https://travis-ci.org/crystal-community/crystal-ann)
[![Dependency Status](https://shards.rocks/badge/github/crystal-community/crystal-ann/status.svg)](https://shards.rocks/github/crystal-community/crystal-ann)
[![Amber Framework](https://img.shields.io/badge/using-amber%20framework-orange.svg)](http://www.amberframework.org/)
[![Gitter](https://badges.gitter.im/veelenga/crystal-ann.svg)](https://gitter.im/veelenga/crystal-ann?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Source code for https://crystal-ann.com.

## Setup

1. [Install Crystal](https://crystal-lang.org/docs/installation/index.html)
2. [Install Amber Framework](https://docs.amberframework.org/getting-started/Installation/)
3. [Install Postgres](http://postgresguide.com/setup/install.html)
4. Create `crystal_ann` and `crystal_ann_test` pg databases

## Development

1. Install project dependencies:

```
$ crystal deps
```

2. Run database migrations:

```
$ amber migrate up
```

3. Create seed data:

```
$ crystal db/seed.cr
```

4. Start app and watch for source changes:

```
$ amber watch
```

## Testing

Migrate test database and run specs:

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

## Contributors

* [veelenga](https://github.com/veelenga) V. Elenhaupt - creator, maintainer
* [hugoabonizio](https://github.com/hugoabonizio) Hugo Abonizio - contributor, maintainer
