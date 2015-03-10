require 'thor'

module Yonobot
  class App < Thor
    desc 'tweet', 'Tweet a sentence.'
    def tweet
      marcov = MarkovChain.new
      tweet = Tweet.new
      tweet.tweet(marcov.sentence)
    end

    desc 'analysis', 'Analysis tweets.'
    def analysis
      csv = 'tweets.csv'
      analyzer = Analyzer.new
      analyzer.store_csv(csv)
    end
  end
end
