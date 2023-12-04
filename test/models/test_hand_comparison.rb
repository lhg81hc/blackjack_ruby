# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module TestHandComparison
  class TestValidation < Minitest::Test
    def setup
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card])
    end

    def test_nil_dealder_hand
      assert_raises(RuntimeError, 'Dealer hand must be present') do
        BlackjackRuby::Models::HandComparison.new(player_hand: @player_hand)
      end
    end

    def test_nil_player_hand
      assert_raises(RuntimeError, 'Player hand must be present') do
        BlackjackRuby::Models::HandComparison.new(dealer_hand: @dealer_hand)
      end
    end

    def valid
      comparison = BlackjackRuby::Models::HandComparison.new(dealer_hand: @dealer_hand, player_hand: @player_hand)

      assert_equal 'a', comparison.dealer_hand.up_card.rank
    end
  end

  class TestPlayerWins < Minitest::Test
    def setup
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])
    end

    def comparison
      @comparison = BlackjackRuby::Models::HandComparison.new(dealer_hand: @dealer_hand, player_hand: @player_hand)
    end

    def assert_player_wins
      assert_equal true, comparison.player_wins?
      assert_equal false, comparison.dealer_wins?
      assert_equal 1, comparison.winner
      assert_equal 'Player', comparison.winner_translation
    end

    def test_when_player_hand_is_blackjack
      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: 'j'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card])

      assert_equal true, @player_hand.blackjack?
      assert_equal true, comparison.player_wins_automatically?
      assert_player_wins
    end

    def test_when_player_hand_is_five_card_charlie
      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '3'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
      player_fourth_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      player_fifth_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new(
        [player_first_card, player_second_card, player_third_card, player_fourth_card, player_fifth_card]
      )

      assert_equal true, @player_hand.five_card_charlie?
      assert_equal true, comparison.player_wins_automatically?
      assert_player_wins
    end

    def test_when_player_hand_is_twenty_one
      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card, player_third_card])

      assert_equal true, @player_hand.twenty_one?
      assert_equal true, comparison.player_wins_automatically?
      assert_player_wins
    end

    def test_when_dealder_hand_is_bust_and_player_hand_is_not
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
      dealer_third_card = OpenStruct.new(rank: OpenStruct.new(val: '6'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card, dealer_third_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card, player_third_card])

      assert_equal true, @dealer_hand.bust?
      assert_equal false, @player_hand.bust?
      assert_equal false, comparison.player_wins_automatically?
      assert_player_wins
    end

    def test_when_dealer_hand_and_player_hand_both_are_not_bust_and_player_hand_is_better
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card, player_third_card])

      assert_equal false, @dealer_hand.bust?
      assert_equal false, @player_hand.bust?
      assert_equal false, comparison.player_wins_automatically?
      assert_player_wins
    end
  end
end

module TestHandComparison
  class TestDealerWins < Minitest::Test
    def setup
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])
    end

    def comparison
      @comparison = BlackjackRuby::Models::HandComparison.new(dealer_hand: @dealer_hand, player_hand: @player_hand)
    end

    def assert_dealer_wins
      assert_equal true, comparison.dealer_wins?
      assert_equal false, comparison.player_wins?
      assert_equal 0, comparison.winner
      assert_equal 'Dealer', comparison.winner_translation
    end

    def test_when_player_hand_bust
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: '5'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'k'))
      dealer_third_card = OpenStruct.new(rank: OpenStruct.new(val: '7'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card, dealer_third_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '9'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '9'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card, player_third_card])

      assert_dealer_wins
    end

    def test_when_dealer_hand_is_blackjac_and_player_hand_is_not
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: 'a'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: 'q'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '9'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '9'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card])

      assert_dealer_wins
    end

    def test_when_dealer_hand_and_player_hand_both_are_not_bust_and_dealer_hand_is_better
      dealer_first_card = OpenStruct.new(rank: OpenStruct.new(val: '8'))
      dealer_second_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @dealer_hand = BlackjackRuby::Models::DealerHand.new([dealer_first_card, dealer_second_card])

      player_first_card = OpenStruct.new(rank: OpenStruct.new(val: '3'))
      player_second_card = OpenStruct.new(rank: OpenStruct.new(val: '4'))
      player_third_card = OpenStruct.new(rank: OpenStruct.new(val: '10'))
      @player_hand = BlackjackRuby::Models::PlayerHand.new([player_first_card, player_second_card, player_third_card])

      assert_dealer_wins
    end
  end

  class TestSameBestScore < Minitest::Test

  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
