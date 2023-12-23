require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

class TestBase < Minitest::Test
  def setup
    @dealer_up_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
    player_cards = [OpenStruct.new(rank: OpenStruct.new(val: 'a')), OpenStruct.new(rank: OpenStruct.new(val: 'k'))]
    @player_hand = BlackjackRuby::Hand::PlayerHand.new(player_cards)
    @strategy = BlackjackRuby::Strategies::Base.new(@dealer_up_card, @player_hand)
  end

  def test_initialize
    assert_equal @dealer_up_card, @strategy.dealer_up_card
    assert_equal @player_hand, @strategy.player_hand
    assert_instance_of Hash, @strategy.strategies
  end

  def test_dealer_up_card_rank
    assert_equal '2', @strategy.dealer_up_card_rank
  end

  def test_player_card_ranks
    assert_equal 'a,10', @strategy.player_card_ranks
  end
end

