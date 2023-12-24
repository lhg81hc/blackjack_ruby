# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

class TestRound < Minitest::Test
  def setup
    @shoe_of_cards = mock_shoe_of_cards
    @betting_boxes = [mock_betting_box]
    @round = BlackjackRuby::Models::Round.new(shoe_of_cards: @shoe_of_cards, betting_boxes: @betting_boxes)
  end

  def test_initialize
    assert_equal @shoe_of_cards, @round.shoe_of_cards
    assert_equal @betting_boxes, @round.betting_boxes
    assert_nil @round.dealer_hand
  end

  def test_setup
    assert_nil @round.dealer_hand
    @round.setup
    refute_nil @round.dealer_hand
  end

  def test_validate_shoe_of_cards
    assert_raises(RuntimeError, 'Shoe can not be blank') do
      BlackjackRuby::Models::Round.new(betting_boxes: @betting_boxes)
    end
  end

  def test_validate_betting_boxes
    assert_raises(RuntimeError, 'Betting boxes can not be blank') do
      BlackjackRuby::Models::Round.new(shoe_of_cards: @shoe_of_cards, betting_boxes: [])
    end
  end

  def test_deal_player_hands
    mock_card1 = OpenStruct.new(rank: OpenStruct.new(val: '10'))
    mock_card2 = OpenStruct.new(rank: OpenStruct.new(val: '3'))

    @round.stub(:shoe_of_cards, mock_shoe_of_cards) do
      mock_shoe_of_cards.expect(:draw, mock_card1)
      mock_shoe_of_cards.expect(:draw, mock_card2)
    end

    betting_box = mock_betting_box
    @round.stub(:betting_boxes, [betting_box]) do
      betting_box.expect(:deal_initial_hand, nil, [[mock_card1, mock_card2]])
    end

    @round.deal_player_hands

    mock_shoe_of_cards.verify
    betting_box.verify
  end

  def test_deal_dealer_hand
    # You may need to mock or stub the shoe_of_cards.draw method for this test
    # Ensure to cover different scenarios and edge cases
  end

  private

  def mock_shoe_of_cards
    BlackjackRuby::Models::Shoe.new(number_of_decks: 6)
    # Implement a mock or stub for the shoe_of_cards
  end

  def mock_betting_box
    BlackjackRuby::Models::BettingBox.new(index: 0, bet: 25)
    # Implement a mock or stub for the betting_box
  end
end
