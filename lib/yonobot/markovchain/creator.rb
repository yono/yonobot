module Yonobot::MarkovChain
  class Creator < Base
    def sentence
      words = []
      prefix = START_SENTENCE
      loop do
        nodes = collection.find(prefix: prefix)
        node = nodes.first
        break unless node
        suffix = node["suffix"].sample

        # 文末まで来たら終わり
        break if suffix == END_SENTENCE

        words << suffix

        prefix = [prefix[1], suffix]
      end
      words.join("")
    end
  end
end
