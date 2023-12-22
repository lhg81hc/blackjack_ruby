# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

# rubocop:disable Metrics/AbcSize
class TestBettingBox < Minitest::Test
  def setup
    @betting_box = BlackjackRuby::Models::BettingBox.new(index: 0, bet: 10)
  end

  def test_initialize
    assert_equal 0, @betting_box.index
    assert_equal 10, @betting_box.bet
    assert_equal [], @betting_box.player_hands
  end

  def test_deal_initial_hand
    cards = [OpenStruct.new(rank: OpenStruct.new(val: 'a')), OpenStruct.new(rank: OpenStruct.new(val: 'k'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands
    assert_instance_of BlackjackRuby::Hand::PlayerHand, @betting_box.player_hands.first
    assert_equal cards, @betting_box.player_hands.first.cards
    assert_equal 10, @betting_box.player_hands.first.bet
    assert_equal @betting_box, @betting_box.player_hands.first.betting_box
  end

  def test_split
    cards = [OpenStruct.new(rank: OpenStruct.new(val: 'a')), OpenStruct.new(rank: OpenStruct.new(val: 'a'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    @betting_box.split(0)

    assert_equal 2, @betting_box.total_hands
    assert_equal 10, @betting_box.player_hands.first.bet
    assert_equal 10, @betting_box.player_hands.last.bet
    assert_equal @betting_box, @betting_box.player_hands.first.betting_box
    assert_equal @betting_box, @betting_box.player_hands.last.betting_box
  end

  def test_double_valid_hand
    cards = [OpenStruct.new(rank: OpenStruct.new(val: '10')), OpenStruct.new(rank: OpenStruct.new(val: '8'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    @betting_box.double_down(0)

    assert_equal 1, @betting_box.total_hands
    assert_equal 20, @betting_box.player_hands.first.bet
    assert @betting_box.player_hands.first.double_down
  end

  def test_double_invalid_hand
    cards = [OpenStruct.new(rank: OpenStruct.new(val: '10')), OpenStruct.new(rank: OpenStruct.new(val: 'a'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    assert_raises(RuntimeError, 'Hand is invalid to double') do
      @betting_box.double_down(0)
    end

    assert_equal 1, @betting_box.total_hands
    assert_equal 10, @betting_box.player_hands.first.bet
  end

  def test_stay
    cards = [OpenStruct.new(rank: OpenStruct.new(val: 'q')), OpenStruct.new(rank: OpenStruct.new(val: 'j'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    @betting_box.stay(0)

    assert_equal true, @betting_box.player_hands.first.stayed
  end

  def test_stay_invalid_hand
    cards = [OpenStruct.new(rank: OpenStruct.new(val: '8')), OpenStruct.new(rank: OpenStruct.new(val: '9'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    assert_raises(RuntimeError, 'Hand not found') do
      @betting_box.stay(1) # Try to stay on a non-existent hand
    end

    assert_equal false, @betting_box.player_hands.first.stayed
  end

  def test_hit
    cards = [OpenStruct.new(rank: OpenStruct.new(val: '7')), OpenStruct.new(rank: OpenStruct.new(val: '4'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    new_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    @betting_box.hit(0, new_card)

    assert_equal 3, @betting_box.player_hands.first.cards.length
    assert_equal new_card, @betting_box.player_hands.first.cards.last
  end

  def test_hit_invalid_hand
    cards = [OpenStruct.new(rank: OpenStruct.new(val: '3')), OpenStruct.new(rank: OpenStruct.new(val: '10'))]
    @betting_box.deal_initial_hand(cards)

    assert_equal 1, @betting_box.total_hands

    new_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))

    assert_raises(RuntimeError, 'Hand not found') do
      @betting_box.hit(1, new_card) # Try to hit on a non-existent hand
    end

    assert_equal 2, @betting_box.player_hands.first.cards.length
  end
end
# rubocop:enable Metrics/AbcSize
