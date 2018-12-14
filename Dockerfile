FROM ruby:2.5.3
ENV LANG C.UTF-8
RUN apt-get update && apt-get -y install mecab libmecab-dev mecab-ipadic-utf8
RUN gem install bundler
ADD . /yonobot
WORKDIR /yonobot
RUN bundle install
