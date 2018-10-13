require 'natto'

module Yonobot
  class Parser
    def parse(text)
      natto.parse(text)
    end

    private

    def natto
      return @natto if defined?(@natto)

      if additional_dicts
        @natto = Natto::MeCab.new(userdic: additional_dicts)
      else
        @natto = Natto::MeCab.new
      end

      @natto
    end

    def additional_dicts
      @additional_dicts ||= Dir.glob("../../dic/*.dic").join(",")
    end
  end
end
