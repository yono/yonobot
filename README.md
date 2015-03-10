# yonobot

Tweet with markovchain algorism.

## Requirements

* Ruby
* MongoDB
* MeCab

### Mac

```bash
$ brew install mongodb mecab mecab-ipadic
```

## Installation

```bash
$ git clone git://github.com/yono/yonobot.git
$ cd yonobot
$ bundle install --path vendor/bundle
```

## Usage

### Show help

```bash
$ bundle exec bin/yonobot
```

### Analyze and store data from tweets.csv

Download tweets.csv from https://twitter.com and place it to project root directory.

```bash
$ bundle exec bin/yonobot analysis
```

## LICENSE

MIT License
