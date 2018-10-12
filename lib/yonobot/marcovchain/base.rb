module Yonobot::MarkovChain
  NONWORD = "\n"
  START_SENTENCE = [NONWORD, NONWORD]
  END_SENTENCE = NONWORD

  class Base
    private

    def collection
      return @collection if defined?(@collection)

      mongo = MongoDB.new
      @collection = mongo.collection
    end
  end
end
