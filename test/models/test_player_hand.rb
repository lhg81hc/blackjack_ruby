# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

# rubocop:disable Metrics/AbcSize
class TestPlayerHand < Minitest::Test
  def test_can_split_when_pair_of_aces
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))

    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    assert_equal true, hand.can_split?
    assert_equal true, hand.options['hit']
  end

  def test_can_split_when_normal_pair
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))

    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    assert_equal true, hand.can_split?
    assert_equal true, hand.options['split']
  end

  def test_can_split_when_both_cards_are_face_or_ten_card
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'j'))

    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    assert_equal true, hand.can_split?
    assert_equal true, hand.options['split']
  end

  def test_can_not_plit_unless_pair
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'q'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '3'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal false, hand.can_split?
    assert_equal false, hand.options['split']
  end

  def test_can_not_plit_unless_two_card
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    hand.add_card(third_card)

    assert_equal false, hand.can_split?
    assert_equal false, hand.options['split']
  end

  def test_can_hit_and_can_double
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal true, hand.can_hit?
    assert_equal true, hand.options['hit']
    assert_equal true, hand.can_double?
    assert_equal true, hand.options['double']
  end

  def test_can_hit_and_can_double_when_blackjack
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'q'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal false, hand.can_hit?
    assert_equal false, hand.options['hit']
    assert_equal false, hand.can_double?
    assert_equal false, hand.options['double']
  end

  def test_can_hit_and_can_double_when_already_double
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '9'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    hand.doubled = true

    assert_equal false, hand.can_hit?
    assert_equal false, hand.options['hit']
    assert_equal false, hand.can_double?
    assert_equal false, hand.options['double']
  end

  def test_can_hit_and_can_double_when_bust
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])
    hand.add_card(third_card)

    assert_equal false, hand.can_hit?
    assert_equal false, hand.options['hit']
    assert_equal false, hand.can_double?
    assert_equal false, hand.options['double']
  end

  def test_payout_odds_when_blackjack
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal 2.0, hand.payout_odds
  end

  def test_payout_odds_when_normal_hand
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal 1.0, hand.payout_odds
  end

  def test_doubled?
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
    hand = BlackjackRuby::Models::PlayerHand.new([first_card, second_card])

    assert_equal false, hand.doubled?

    hand.doubled = true
    assert_equal true, hand.doubled?
  end
end
# rubocop:enable Metrics/AbcSize
