# Crystal [ANN]

Announce your new project, blog post, version update or other Crystal resource useful for community.

## Installation

Create a pg database called `crystal_ann` and configure the `config/database.yml`
to provide the credentials to access the table.

Then:
```
shards update
amber migrate up
```

## Usage

To run the demo:
```
crystal build src/crystal-ann.cr
./crystal-ann
```

## Contributing

1. Fork it ( https://github.com/veelenga/crystal-ann/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
