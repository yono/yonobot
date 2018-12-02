FROM ruby:2.5.3
ENV LANG C.UTF-8
RUN apt-get update
RUN apt-get -y install mecab libmecab-dev mecab-ipadic-utf8
RUN gem install bundler
ADD . /opt/yonobot
WORKDIR /opt/yonobot
RUN bundle install
CMD bundle exec bin/yonobot
