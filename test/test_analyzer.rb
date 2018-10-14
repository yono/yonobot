require 'test_helper'

class TestAnalyzer < Test::Unit::TestCase
  def test_remove_twitter_username
    analyzer = ::Yonobot::MarkovChain::Analyzer.new
    result = analyzer.send(:remove_twitter_username, "@yono こんにちは")
    assert_equal result, " こんにちは"
  end
end
