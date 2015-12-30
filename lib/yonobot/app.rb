require 'thor'

module Yonobot
  class App < Thor
    desc 'tweet', 'Tweet a sentence. (mute from 0:00 to 6:00)'
    def tweet
      if Time.now.hour > 6
        marcov = MarkovChain.new
        tweet = Tweet.new
        tweet.tweet(marcov.sentence)
      end
    end

    desc 'analysis', 'Analysis tweets.'
    def analysis
      csv = 'tweets.csv'
      analyzer = Analyzer.new
      analyzer.store_csv(csv)
    end
  end
end
