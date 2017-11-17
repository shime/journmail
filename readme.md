# One Sentence Per Day

[![Build Status](https://travis-ci.org/shime/one-sentence-per-day.svg)](https://travis-ci.org/shime/one-sentence-per-day)
[![GPA](https://codeclimate.com/github/shime/one-sentence-per-day/badges/gpa.svg)](https://codeclimate.com/github/shime/one-sentence-per-day)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e24ed87860920e5625da/test_coverage)](https://codeclimate.com/github/shime/one-sentence-per-day/test_coverage)
[![To Do](https://badge.waffle.io/shime/one-sentence-per-day.svg?columns=To%20Do)](https://waffle.io/shime/one-sentence-per-day)

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
