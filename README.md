# yonobot

Tweet with markovchain algorism.

[![CircleCI](https://circleci.com/gh/yono/yonobot.svg?style=svg)](https://circleci.com/gh/yono/yonobot)

## Requirements

* Docker

## Installation

```bash
$ git clone git://github.com/yono/yonobot.git
$ cd yonobot
$ docker-compose build
```

## Usage

### Show help

```bash
$ docker-compose run web bundle exec bin/yonobot
```

### Analyze and store data from tweets.csv

Download tweets.csv from https://twitter.com and place it to project root directory.

```bash
$ docker-compose run web bundle exec bin/yonobot analysis
```

## LICENSE

MIT License
