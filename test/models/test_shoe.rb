# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

class TestShoe < Minitest::Test
  def setup
    @shoe = BlackjackRuby::Models::Shoe.new
  end

  def test_initialize
    assert_equal 2, @shoe.number_of_decks
    assert_equal 104, @shoe.count
  end

  def test_valid_number_of_decks
    valid_shoe = BlackjackRuby::Models::Shoe.new(number_of_decks: 3)

    assert_equal 3, valid_shoe.number_of_decks
    assert_equal 156, valid_shoe.count
  end

  def test_invalid_number_of_decks
    assert_raises(RuntimeError, 'Shoe must contain at least one deck of card') do
      BlackjackRuby::Models::Shoe.new(number_of_decks: 0)
    end
  end

  def test_remaining
    @shoe.take_cards(100)

    assert_equal 4, @shoe.count
  end

  def test_draw_top
    initial_count = @shoe.count
    @shoe.draw

    assert_equal initial_count - 1, @shoe.count
  end

  def test_draw_bottom
    initial_count = @shoe.count
    @shoe.draw('bottom')

    assert_equal initial_count - 1, @shoe.count
  end

  def test_draw_invalid_position
    assert_raises(RuntimeError, "Invalid 'draw position' argument") do
      @shoe.draw('invalid')
    end
  end

  def test_take_cards_invalid_count
    assert_raises(RuntimeError, 'Must take at least 1 card') do
      @shoe.take_cards(0)
    end
  end

  def test_take_cards
    cards = @shoe.take_cards(3)

    assert_instance_of Array, cards
    assert_equal 3, cards.size
  end

  def test_take_a_card_from_a_none_empty_shoe
    assert_equal @shoe.count, 104
    card = @shoe.take_a_card

    refute_nil card
    assert_equal @shoe.count, 103
  end

  def test_take_a_card_from_an_empty_deck
    assert_equal @shoe.count, 104
    @shoe.take_cards(104)

    assert_equal true, @shoe.empty?

    card = @shoe.take_a_card
    assert_nil card
  end

  def test_pick_a_card_that_is_in_the_deck
    card = @shoe.pick('q', 'hearts')

    assert_equal card.to_s, 'queen of hearts'
  end

  def test_pick_a_card_which_has_invalid_rank_to_raise_error
    assert_raises(RuntimeError) { @shoe.pick('bar', 'hearts') }
  end

  def test_pick_a_card_which_has_invalid_suite_to_raise_error
    assert_raises(RuntimeError) { @shoe.pick('10', 'hear') }
  end

  def test_pick_a_card_that_is_not_in_the_deck
    assert_equal @shoe.count, 104
    @shoe.take_cards(104)

    assert_equal true, @shoe.empty?

    card = @shoe.pick('j', 'diamonds')
    assert_nil card
  end
end
