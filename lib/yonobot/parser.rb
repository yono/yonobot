require 'natto'

module Yonobot
  class Parser
    attr_accessor :nm
    def initialize
      dicts = Dir.glob("../../dic/*.dic").join(",")
      @nm = nil
      if dicts
        @nm = Natto::MeCab.new(userdic: dicts)
      else
        @nm = Natto::MeCab.new
      end
    end
  end
end
