require 'uri'
require 'cgi'
require 'json'

module Yonobot::MarkovChain
  class Analyzer < Base

    def store_tweets(filename)
      h = {}
      count = 0
      File.open('tweet.js') do |file|
        table = JSON.load(file)
        table.each do |row|
          next if row["retweeted"]
          text = row["full_text"]
          valid = valid?(text)
          count += 1 if valid

          puts "#{count}/#{table.size}"
          puts "#{valid} #{text}"
          if valid
            text = normalize(text)
            surfaces = [NONWORD, NONWORD]
            parser.parse(text) do |node|
              surfaces << node.surface
            end
            surfaces << NONWORD

            # データ突っ込む
            surfaces.each_cons(3).each do |pre_suf|
              suffix = pre_suf.pop
              prefix = pre_suf

              h[prefix] ||= []
              h[prefix] << suffix
            end
          end
        end
      end

      # TODO: sqlite3 向けに作り直す
      collection.drop
      array = h.map do |key, value|
        { insert_one:
          { prefix: key, suffix: value }
        }
      end
      collection.bulk_write array
    end

    private

    def valid?(text)
      # URL 入ってたらダメ
      have_url = URI.regexp =~ text

      # 「」が含まれたらダメ
      have_kagi = /「|」/ =~ text

      # ()（）が含まれたらダメ
      have_kakko = /\(|\)|（|）/ =~ text

      !have_url && !have_kagi && !have_kakko
    end

    def normalize(text)
      text = remove_twitter_client_keywords(text)
      text = remove_twitter_username(text)
      text = remove_twitter_hashtag(text)
      text = text.gsub(/\n/, "")
      text = CGI.unescapeHTML(text)
      text = text.strip
    end

    def remove_twitter_client_keywords(text)
      text = text.gsub(/\*tp/, "")
      text = text.gsub(/\*p/, "")
      text = text.gsub(/\*Tw\*/, "")
    end

    def remove_twitter_username(text)
      text.gsub(/@[^\s]+/, "")
    end

    def remove_twitter_hashtag(text)
      text.gsub(/#[^\s]+/, "")
    end

    def parser
      @parser ||= Yonobot::Parser.new
    end
  end
end
