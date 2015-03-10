require 'csv'
require 'uri'
require 'cgi'

module Yonobot
  class Analyzer
    NONWORD = "\n"
    START_SENTENCE = [NONWORD, NONWORD]
    END_SENTENCE = NONWORD

    def initialize
      @parser = Parser.new
      mongo = MongoDB.new
      @coll = mongo.coll
    end

    def store_csv(filename)
      table = CSV.table('tweets.csv', headers: true, header_converters: :symbol)
      count = 0
      h = {}
      table.each do |row|
        text = row[:text]
        next if text.is_a?(Fixnum)

        is_valid = valid?(text)
        count = count + 1 if is_valid

        puts "#{count}/#{table.size}"
        puts "#{is_valid} #{text}"
        if is_valid
          text = normalize(text)
          surfaces = [NONWORD, NONWORD]
          @parser.nm.parse(text) do |n|
            surfaces << n.surface
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
        @coll.insert(doc)
      end
    end

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
      text = text.gsub(/\*tp/, "")
      text = text.gsub(/\*p/, "")
      text = text.gsub(/\*Tw\*/, "")
      # @username は消す
      text = text.gsub(/@[^\s]+/, "")
      # #hashtag は消す
      text = text.gsub(/#[^\s]+/, "")
      text = text.gsub(/\n/, "")
      text = CGI.unescapeHTML(text)
      text = text.strip
    end
  end
end
