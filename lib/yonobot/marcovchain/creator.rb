module Yonobot::MarkovChain
  class Creator < Base
    def sentence
      words = []
      prefix = START_SENTENCE
      loop do
        _suffix = collection.find_one(prefix: prefix)

        # _suffix からランダムに1つ選ぶ
        suffix = _suffix["suffix"][rand(_suffix["suffix"].count)]

        # 文末まで来たら終わり
        break if suffix == END_SENTENCE

        words << suffix

        # prefixを1つずらす
        prefix.delete_at(0)
        prefix << suffix
      end
      words.join("")
    end
  end
end
