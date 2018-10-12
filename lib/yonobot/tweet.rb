require 'twitter'
require 'dotenv'
Dotenv.load

module Yonobot
  class Tweet

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

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
    end
  end
end
