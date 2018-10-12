require 'thor'

module Yonobot
  class App < Thor
    desc 'tweet', 'Tweet a sentence. (mute from 0:00 to 6:00)'
    def tweet
      return if sleeping?

      tweet.tweet(sentence)
    end

    desc 'analysis', 'Analysis tweets.'
    def analysis
      csv = 'tweets.csv'
      analyzer.store_csv(csv)
    end

    desc 'replies', 'Send replies'
    def replies
      return if sleeping?

      current = Time.now
      tweet.mentions_timeline.each do |mention|
        # get only 10 minites
        next if mention.created_at + (60 * 10) < current

        tweet.reply("@#{mention.user.screen_name} #{sentence}", in_reply_to_status: mention)
      end
    end

    private

    def sleeping?
      Time.now.hour < 7
    end

    def marcov
      @marcov ||= MarcovChain.new
    end

    def sentence
      marcov.sentence
    end

    def tweet
      @tweet ||= Tweet.new
    end

    def analyzer
      @analyzer ||= Analyzer.new
    end
  end
end
