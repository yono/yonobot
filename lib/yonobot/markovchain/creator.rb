require 'sqlite3'

module Yonobot::MarkovChain
  class Creator < Base
    def sentence
      words = []
      prefix_words = START_SENTENCE
      db = SQLite3::Database.new("dic/markovchaings.db")
      loop do
        prefix = db.execute("SELECT id FROM prefix_words WHERE word1 = ? AND word2 = ?", *prefix_words)
        id = prefix[0][0]

        break unless id

        suffix = db.execute("SELECT word FROM suffix_words WHERE prefix_id = ? ORDER BY RANDOM() LIMIT 1", id)
        suffix_word = suffix[0][0]

        # 文末まで来たら終わり
        break if suffix_word == END_SENTENCE

        words << suffix_word

        prefix_words = [prefix_words[1], suffix_word]
      end
      words.join("")
    end
  end
end
