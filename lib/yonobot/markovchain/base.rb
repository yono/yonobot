module Yonobot::MarkovChain
  NONWORD = "\n"
  START_SENTENCE = [NONWORD, NONWORD]
  END_SENTENCE = NONWORD

  class Base
    private

    def collection
      return @collection if defined?(@collection)

      @collection = mongo.collection
    end

    def mongo
      @mongo ||= Yonobot::MongoDB.new
    end
  end
end
