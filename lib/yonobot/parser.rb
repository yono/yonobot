require 'natto'

module Yonobot
  class Parser
    def parse(text, &block)
      natto.parse(text, &block)
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
