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

    desc 'replies', 'Send replies'
    def replies
      tweet = Tweet.new
      current = Time.now
      marcov = MarkovChain.new
      tweet.mentions_timeline.each do |mention|
        # get only 5 minites
        next if mention.created_at + (60 * 5) < current

        sentence = marcov.sentence
        tweet.reply("@#{mention.user.screen_name} #{sentence}", in_reply_to_status: mention)
      end
    end
  end
end
