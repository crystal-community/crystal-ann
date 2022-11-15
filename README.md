# Crystal [ANN]
[![Build Status](https://travis-ci.org/crystal-community/crystal-ann.svg?branch=master)](https://travis-ci.org/crystal-community/crystal-ann)
[![GitHub release](https://img.shields.io/github/release/crystal-community/crystal-ann.svg)](https://github.com/crystal-community/crystal-ann)
[![Amber Framework](https://img.shields.io/badge/using-amber%20framework-orange.svg)](http://www.amberframework.org/)
[![Gitter](https://badges.gitter.im/veelenga/crystal-ann.svg)](https://gitter.im/veelenga/crystal-ann?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Twitter Follow](https://img.shields.io/twitter/follow/crystallang_ann.svg?style=social&label=Follow)](https://twitter.com/crystallang_ann)

Source code for https://crystal-ann.com.

<p>
  <img src="https://github.com/veelenga/bin/raw/master/crystal-ann/ipad_mockup.png" width="600" />
  <img src="https://github.com/veelenga/bin/raw/master/crystal-ann/iphone_mockup.png" width="200" />
</p>

## Setup

1. [Install Crystal](https://crystal-lang.org/docs/installation/index.html)
2. [Install Amber Framework](https://docs.amberframework.org/amber/getting-started)
3. [Install Postgres](http://postgresguide.com/setup/install.html)
4. Create `crystal_ann` and `crystal_ann_test` pg databases

## Development

1. Install project dependencies:

```
$ shards install
```

2. Run database migrations:

```
$ amber db migrate
```

3. Seed data:

```
$ amber db seed
```

4. Start app and watch for source changes:

```
$ amber w
```

## Testing

Migrate test database and run specs:

```
$ MICRATE_RUN_UP=true crystal spec
```

## Docker

Run the app using docker-compose

``` sh
docker-compose up
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

TWITTER_OAUTH_CONSUMER_KEY
TWITTER_OAUTH_CONSUMER_SECRET
```

## Contributors

* [veelenga](https://github.com/veelenga) V. Elenhaupt - creator, maintainer
* [hugoabonizio](https://github.com/hugoabonizio) Hugo Abonizio - contributor, maintainer
* [janczer](https://github.com/janczer) Janczer - contributor
* [lex111](https://github.com/lex111) Alexey Pyltsyn - contributor
* [vaibhavsingh97](https://github.com/vaibhavsingh97) Vaibhav Singh - contributor
* [PAPERPANKS](https://github.com/PAPERPANKS) Pankaj Kumar Gautam - contributor
