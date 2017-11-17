# Journmail

[![Build Status](https://travis-ci.org/shime/one-sentence-per-day.svg)](https://travis-ci.org/shime/one-sentence-per-day)
[![Maintainability](https://api.codeclimate.com/v1/badges/1e1928639ee2bc312246/maintainability)](https://codeclimate.com/github/shime/journmail/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1e1928639ee2bc312246/test_coverage)](https://codeclimate.com/github/shime/journmail/test_coverage)
[![To Do](https://badge.waffle.io/shime/journmail.svg?columns=To%20Do)](https://waffle.io/shime/journmail)

Teach yourself consistency by keeping a journal and writing one sentence per day in it.

## Stack

* Ruby
* PostgreSQL

## Development

Install dependencies

```shell
$ bundle install
```

Spin up a development server

```shell
$ rackup
```

Run tests

```shell
$ bundle exec rake
```

Set up database

```shell
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

## License

MIT
