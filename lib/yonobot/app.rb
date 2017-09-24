require 'thor'

module Yonobot
  class App < Thor
    desc 'tweet', 'Tweet a sentence. (mute from 0:00 to 6:00)'
    def tweet
      return if sleeping?

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

    desc 'replies', 'Send replies'
    def replies
      return if sleeping?

      tweet = Tweet.new
      current = Time.now
      marcov = MarkovChain.new
      tweet.mentions_timeline.each do |mention|
        # get only 10 minites
        next if mention.created_at + (60 * 10) < current

        sentence = marcov.sentence
        tweet.reply("@#{mention.user.screen_name} #{sentence}", in_reply_to_status: mention)
      end
    end

    private

    def sleeping?
      Time.now.hour < 7
    end
  end
end
