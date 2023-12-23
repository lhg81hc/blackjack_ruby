require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

class TestHardTotalsStrategy < Minitest::Test
  def setup
    @dealer_up_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
    player_cards = [OpenStruct.new(rank: OpenStruct.new(val: '6')), OpenStruct.new(rank: OpenStruct.new(val: '9'))]
    @player_hand = BlackjackRuby::Hand::PlayerHand.new(player_cards)
    @strategy = BlackjackRuby::Strategies::HardTotalsStrategy.new(@dealer_up_card, @player_hand)
  end

  def test_build_strategies
    assert_equal BlackjackRuby::Strategies::HardTotalsStrategy::DEFAULT_STRATEGIES, @strategy.build_strategies
  end

  def test_hard_total_scores
    assert_equal BlackjackRuby::Strategies::HardTotalsStrategy::DEFAULT_STRATEGIES.keys, @strategy.hard_total_scores
  end

  def test_player_score
    assert_equal 15, @strategy.player_score
  end

  def test_find_move
    assert_equal 'Stay', @strategy.find_move
  end

  def test_find_move!
    assert_equal 'Stay', @strategy.find_move
  end
end
