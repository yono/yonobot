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

Download tweet.js from https://twitter.com and place it to project root directory.

Please edit top row of tweet.js like below.

```diff
1c1
< window.YTD.tweet.part0 = [ {
---
> [ {
```

```bash
$ docker-compose run web bundle exec bin/yonobot analysis
```

## LICENSE

MIT License
