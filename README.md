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

## Deployment

```
$ heroku create app-name --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal.git
$ heroku config:set GITHUB_ID=github_client_id
$ heroku config:set GITHUB_SECRET=github_client_secret
$ git push heroku master
```
