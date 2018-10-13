module Yonobot::MarkovChain
  class Creator < Base
    def sentence
      words = []
      prefix = START_SENTENCE
      loop do
        suffixes = collection.find_one(prefix: prefix)

        # _suffix からランダムに1つ選ぶ
        suffix = suffixes["suffix"][rand(suffixes["suffix"].count)]

        # 文末まで来たら終わり
        break if suffix == END_SENTENCE

        words << suffix

        # prefixを1つずらす
        prefix = [prefix[1], suffix]
      end
      words.join("")
    end
  end
end
