require 'twitter'
require 'dotenv'
Dotenv.load

module Yonobot
  class Twitter
    def initialize(twitter_client_class=::Twitter::REST::Client)
      @twitter_client_class = twitter_client_class
    end

    def tweet(sentence)
      client.update(sentence)
    end

    def reply(sentence, *args)
      client.update(sentence, *args)
    end

    def mentions_timeline
      client.mentions_timeline
    end

    private

    def twitter_client_class
      @twitter_client_class
    end

    def client
      @client ||= twitter_client_class.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
    end
  end
end
