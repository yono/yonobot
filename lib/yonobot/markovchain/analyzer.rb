require 'csv'
require 'uri'
require 'cgi'

module Yonobot::MarkovChain
  class Analyzer < Base

    def store_csv(filename)
      table = CSV.table('tweets.csv', headers: true, header_converters: :symbol)
      count = 0
      h = {}
      table.each do |row|
        text = row[:text]
        next if text.is_a?(Fixnum)

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

      h.each do |key, value|
        doc = {prefix: key, suffix: value}
        collection.insert_one(doc)
      end
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
