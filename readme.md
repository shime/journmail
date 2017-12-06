# [Journmail](https://journmail.com)

[![Build Status](https://travis-ci.org/shime/journmail.svg)](https://travis-ci.org/shime/journmail)
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

Spin up a fake mail server

```shell
$ gem install mailcatcher
$ mailcatcher
```

Visit [http://localhost:1080/](http://localhost:1080/) to preview emails.

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
