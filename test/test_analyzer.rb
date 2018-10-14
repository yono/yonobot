require 'test_helper'

class TestAnalyzer < Test::Unit::TestCase
  def test_remove_twitter_username
    analyzer = ::Yonobot::MarkovChain::Analyzer.new
    result = analyzer.send(:remove_twitter_username, "@yono こんにちは")
    assert_equal result, " こんにちは"
  end

  def test_remove_twitter_client_keywords
    analyzer = ::Yonobot::MarkovChain::Analyzer.new
    result = analyzer.send(:remove_twitter_client_keywords, "おはよう *tp *p *Tw*")
    assert_equal result, "おはよう   "
  end

  def test_remove_twitter_hashtag
    analyzer = ::Yonobot::MarkovChain::Analyzer.new
    result = analyzer.send(:remove_twitter_hashtag, "こんばんは #ねむい")
    assert_equal result, "こんばんは "
  end

  def test_store_csv
    pend
  end

  def test_valid?
    pend
  end

  def test_normalize
    pend
  end
end
