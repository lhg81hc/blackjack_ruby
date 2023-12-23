require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

class TestSoftTotalsStrategy < Minitest::Test
  def setup
    @dealer_up_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
    player_cards = [OpenStruct.new(rank: OpenStruct.new(val: '7')), OpenStruct.new(rank: OpenStruct.new(val: '7'))]
    @player_hand = BlackjackRuby::Hand::PlayerHand.new(player_cards)
    @strategy = BlackjackRuby::Strategies::PairSplittingStrategy.new(@dealer_up_card, @player_hand)
  end

  def test_build_strategies
    assert_equal BlackjackRuby::Strategies::PairSplittingStrategy::DEFAULT_STRATEGIES, @strategy.build_strategies
  end

  def test_find_move
    assert_equal 'Split', @strategy.find_move
  end

  def test_find_move!
    assert_equal 'Split', @strategy.find_move
  end
end
