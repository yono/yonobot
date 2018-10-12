module Yonobot
  class MarkovChain
    NONWORD = "\n"
    START_SENTENCE = [NONWORD, NONWORD]
    END_SENTENCE = NONWORD

    def initialize
    end

    def sentence
      words = []
      prefix = START_SENTENCE
      loop do
        _suffix = collection.find_one(prefix: prefix)
        suffix = _suffix["suffix"][rand(_suffix["suffix"].count)]
        break if suffix == END_SENTENCE

        words << suffix

        prefix.delete_at(0)
        prefix << suffix
      end
      words.join("")
    end

    private

    def collection
      return @collection if defined?(@collection)

      mongo = MongoDB.new
      @collection = mongo.collection
    end
  end
end
