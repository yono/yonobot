#!/usr/bin/env ruby
# -*- coding:utf-8 -*-

require 'csv'
require 'uri'
require 'cgi'
require 'natto'
require 'twitter'
require 'mongo'
require 'dotenv'
Dotenv.load

NONWORD = "\n"
START_SENTENCE = [NONWORD, NONWORD]
END_SENTENCE = NONWORD

connection = Mongo::Connection.new
db = connection.db('twitter')
coll = db.collection('malcovchains')

result_tweet = []
prefix = START_SENTENCE
loop do
  _suffix = coll.find_one(prefix: prefix)
  suffix = _suffix["suffix"][rand(_suffix["suffix"].count)]
  break if suffix == END_SENTENCE

  result_tweet << suffix

  prefix.delete_at(0)
  prefix << suffix
end

puts result_tweet.join("")

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

client.update(result_tweet.join(""))
