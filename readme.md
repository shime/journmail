# Journmail

[![Build Status](https://travis-ci.org/shime/journmail.svg)](https://travis-ci.org/shime/journmail)
[![Maintainability](https://api.codeclimate.com/v1/badges/1e1928639ee2bc312246/maintainability)](https://codeclimate.com/github/shime/journmail/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1e1928639ee2bc312246/test_coverage)](https://codeclimate.com/github/shime/journmail/test_coverage)
[![To Do](https://badge.waffle.io/shime/journmail.svg?columns=To%20Do)](https://waffle.io/shime/journmail)

<img height="200" src="https://twobucks.co/assets/images/journmail-logo-new.png"></img>


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
$ bundle exec rackup
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
