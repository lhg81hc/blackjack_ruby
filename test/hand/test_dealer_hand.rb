# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
class TestDealerHand < Minitest::Test
  def test_soft_seventeen_and_hard_seventeen
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))

    soft_seventeen_hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])
    assert_equal true, soft_seventeen_hand.soft_seventeen?
    assert_equal false, soft_seventeen_hand.hard_seventeen?

    first_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))

    hard_seventeen_hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])
    assert_equal false, hard_seventeen_hand.soft_seventeen?
    assert_equal true, hard_seventeen_hand.hard_seventeen?

    first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))

    random_hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])
    assert_equal false, random_hand.soft_seventeen?
    assert_equal false, random_hand.hard_seventeen?
  end

  def test_enough_when_soft_seventeen
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    BlackjackRuby.configure do
      dealer_hits_on_soft_seventeen false
    end

    soft_seventeen_hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])
    assert_equal true, soft_seventeen_hand.soft_seventeen?
    assert_equal true, soft_seventeen_hand.enough?
  end

  def test_enough_when_hard_seventeen
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))

    hard_seventeen_hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])

    assert_equal true, hard_seventeen_hand.hard_seventeen?
    assert_equal true, hard_seventeen_hand.enough?
    assert_equal true, hard_seventeen_hand.can_stay?
    assert_equal true, hard_seventeen_hand.options['stay']
  end

  def test_enough_when_any_scores_over_seventeen_and_not_bust
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))

    hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card, third_card])

    assert_equal false, hand.hard_seventeen?
    assert_equal false, hand.soft_seventeen?
    assert_equal true, hand.enough?
    assert_equal true, hand.can_stay?
    assert_equal true, hand.options['stay']
  end

  def test_enough_when_all_scores_are_under_seventeen
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))

    hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])
    assert_equal [12], hand.scores
    assert_equal false, hand.enough?
    assert_equal false, hand.can_stay?
    assert_equal false, hand.options['stay']
  end

  def test_enough_when_all_scores_are_over_seventeen
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))

    hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card, third_card])
    assert_equal [23], hand.scores
    assert_equal false, hand.enough?
    assert_equal true, hand.can_stay?
    assert_equal true, hand.options['stay']
  end

  def test_can_stay_when_blackjack
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card])

    assert_equal true, hand.blackjack?
    assert_equal true, hand.can_stay?
    assert_equal true, hand.options['stay']
  end

  def test_can_stay_when_bust
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'j'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: 'j'))
    hand = BlackjackRuby::Hand::DealerHand.new([first_card, second_card, third_card])

    assert_equal true, hand.bust?
    assert_equal true, hand.can_stay?
    assert_equal true, hand.options['stay']
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
