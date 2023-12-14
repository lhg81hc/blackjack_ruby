# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module TestAbstractHand
  class TestScoreEvaluation < Minitest::Test
    def setup
      first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
      second_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      @hand_without_ace = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

      first_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
      second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      third_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
      @hand_with_one_ace = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])
      @hand_with_one_ace.add_card(third_card)

      first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      @hand_with_two_aces = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

      first_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      second_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      third_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      @hand_with_three_fives = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])
      @hand_with_three_fives.add_card(third_card)
    end

    def test_scores
      assert_equal [11], @hand_without_ace.scores
      assert_equal [11, 21], @hand_with_one_ace.scores.sort
      assert_equal [2, 12, 22], @hand_with_two_aces.scores.sort
      assert_equal [15], @hand_with_three_fives.scores.sort
    end

    def test_card_scores
      assert_equal [[6], [5]], @hand_without_ace.card_scores
      assert_equal [[8], [1, 11], [2]], @hand_with_one_ace.card_scores
      assert_equal [[1, 11], [1, 11]], @hand_with_two_aces.card_scores
      assert_equal [[5], [5], [5]], @hand_with_three_fives.card_scores
    end

    def test_best_score
      assert_equal 11, @hand_without_ace.best_score
      assert_equal 21, @hand_with_one_ace.best_score
      assert_equal 12, @hand_with_two_aces.best_score
      assert_equal 15, @hand_with_three_fives.best_score
    end

    def test_identical_score_cards
      assert_equal false, @hand_without_ace.identical_score_cards?
      assert_equal false, @hand_with_one_ace.identical_score_cards?
      assert_equal true, @hand_with_two_aces.identical_score_cards?
      assert_equal true, @hand_with_three_fives.identical_score_cards?
    end
  end
end

module TestHand
  class TestCharacteristic < Minitest::Test
    def setup
      first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      second_card = OpenStruct.new(rank: OpenStruct.new(val: '3'))

      @hand = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])
    end
  end

  def test_when_five_card_and_not_bust
    assert_equal false, @hand.five_card_charlie?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '2')))
    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '3')))
    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '4')))

    assert_equal true, @hand.five_card_charlie?
  end

  def test_when_five_card_and_bust
    assert_equal false, @hand.five_card_charlie?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '2')))
    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: 'k')))
    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: 'q')))

    assert_equal false, @hand.five_card_charlie?
  end

  def test_bust
    assert_equal false, @hand.bust?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '10')))
    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '9')))

    assert_equal true, @hand.bust?
  end

  def test_card_counting_methods
    # current @hand is 'a,3'
    assert_equal true, @hand.two_cards?
    assert_equal false, @hand.more_than_two_cards?
    assert_equal false, @hand.five_cards?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: '2')))

    assert_equal false, @hand.two_cards?
    assert_equal true, @hand.more_than_two_cards?
    assert_equal false, @hand.five_cards?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: 'k')))

    assert_equal false, @hand.two_cards?
    assert_equal true, @hand.more_than_two_cards?
    assert_equal false, @hand.five_cards?

    @hand.add_card(OpenStruct.new(rank: OpenStruct.new(val: 'a')))

    assert_equal false, @hand.two_cards?
    assert_equal true, @hand.more_than_two_cards?
    assert_equal true, @hand.five_cards?
  end

  def test_identical_rank_cards
    # Current @hand is 'a,3'
    # Test when cards have different ranks
    assert_equal false, @hand.identical_rank_cards?

    # Test when cards have identical ranks
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
    third_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
    hand_identical_ranks = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])
    hand_identical_ranks.add_card(third_card)

    assert_equal true, hand_identical_ranks.identical_rank_cards?
  end

  def test_soft_and_ace_card_and_face_card_and_pair_methods
    # Test when is a pair of ace cards
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    pair_of_aces_hand = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

    assert_equal true, pair_of_aces_hand.pair?
    assert_equal true, pair_of_aces_hand.soft?
    assert_equal true, pair_of_aces_hand.any_ace_card?
    assert_equal false, pair_of_aces_hand.any_face_card_or_ten_card?
    assert_equal false, pair_of_aces_hand.blackjack?

    # Test when is a normal pair
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
    normal_pair_hand = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

    assert_equal true, normal_pair_hand.pair?
    assert_equal false, normal_pair_hand.soft?
    assert_equal false, normal_pair_hand.any_ace_card?
    assert_equal false, normal_pair_hand.any_face_card_or_ten_card?
    assert_equal false, normal_pair_hand.blackjack?

    # Test when is a soft hand
    first_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    soft_hand = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

    assert_equal false, soft_hand.pair?
    assert_equal true, soft_hand.soft?
    assert_equal true, soft_hand.any_ace_card?
    assert_equal false, soft_hand.any_face_card_or_ten_card?
    assert_equal false, soft_hand.blackjack?

    # Test when is a blackjack hand
    first_card = OpenStruct.new(rank: OpenStruct.new(val: 'j'))
    second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
    blackjack_hand = BlackjackRuby::Hand::AbstractHand.new([first_card, second_card])

    assert_equal false, blackjack_hand.pair?
    assert_equal false, blackjack_hand.soft?
    assert_equal true, blackjack_hand.any_ace_card?
    assert_equal true, blackjack_hand.any_face_card_or_ten_card?
    assert_equal true, blackjack_hand.blackjack?
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
