require 'minitest/autorun'
require 'test_helper'
require 'ostruct'

module TestCardValue
  class TestCardValueValidation < Minitest::Test
    def test_valid_rank
      valid_card = OpenStruct.new(rank: OpenStruct.new(val: '2'))
      card_value = BlackjackRuby::Models::CardValue.new(valid_card)

      assert_equal '2', card_value.rank
    end

    def test_invalid_rank
      invalid_card = OpenStruct.new(rank: OpenStruct.new(val: 'foo'))

      assert_raises(RuntimeError, 'Invalid rank') do
        BlackjackRuby::Models::CardValue.new(invalid_card)
      end
    end
  end
end

module TestCardValue
  class TestSmallRankCards < Minitest::Test
    def setup
      @small_rank_cards = ('2'..'9').map do |rank|
        OpenStruct.new(rank: OpenStruct.new(val: rank))
      end

      @card_value_objects = @small_rank_cards.map { |card| BlackjackRuby::Models::CardValue.new(card) }
    end

    def test_ranks
      expected_ranks = ('2'..'9').to_a
      assert_equal expected_ranks, @card_value_objects.map(&:rank)
    end

    def test_face_card_or_ten_card
      assert_equal Array.new(8, false), @card_value_objects.map(&:face_card_or_ten_card?)
    end

    def test_ace_card
      assert_equal Array.new(8, false), @card_value_objects.map(&:ace_card?)
    end

    def test_order
      expected_orders = (0..7).to_a
      assert_equal expected_orders, @card_value_objects.map(&:order)
    end

    def test_blackjack_rank
      expected_blackjack_ranks = ('2'..'9').to_a
      assert_equal expected_blackjack_ranks, @card_value_objects.map(&:blackjack_rank)
    end

    def test_scores
      expected_scores = (2..9).to_a.map { |num| [num] }
      assert_equal expected_scores, @card_value_objects.map(&:scores)
    end
  end
end

module TestCardValue
  class TestHighRankCards < Minitest::Test
    def setup
      @high_rank_cards = %w[10 j q k].map do |rank|
        OpenStruct.new(rank: OpenStruct.new(val: rank))
      end

      @card_value_objects = @high_rank_cards.map { |card| BlackjackRuby::Models::CardValue.new(card) }
    end

    def test_ranks
      expected_ranks = %w[10 j q k]
      assert_equal expected_ranks, @card_value_objects.map(&:rank)
    end

    def test_face_card_or_ten_card
      assert_equal Array.new(4, true), @card_value_objects.map(&:face_card_or_ten_card?)
    end

    def test_ace_card
      assert_equal Array.new(4, false), @card_value_objects.map(&:ace_card?)
    end

    def test_order
      expected_orders = [8, 9, 10, 10]
      assert_equal expected_orders, @card_value_objects.map(&:order)
    end

    def test_blackjack_rank
      expected_blackjack_ranks = Array.new(4, '10')
      assert_equal expected_blackjack_ranks, @card_value_objects.map(&:blackjack_rank)
    end

    def test_scores
      expected_scores = Array.new(4, [10])
      assert_equal expected_scores, @card_value_objects.map(&:scores)
    end
  end
end

module TestCardValue
  class TestAceCards < Minitest::Test
    def setup
      @ace_cards = ['a'].map do |rank|
        OpenStruct.new(rank: OpenStruct.new(val: rank))
      end

      @card_value_objects = @ace_cards.map { |card| BlackjackRuby::Models::CardValue.new(card) }
    end

    def test_ranks
      expected_ranks = ['a']
      assert_equal expected_ranks, @card_value_objects.map(&:rank)
    end

    def test_face_card_or_ten_card
      assert_equal [false], @card_value_objects.map(&:face_card_or_ten_card?)
    end

    def test_ace_card
      assert_equal [true], @card_value_objects.map(&:ace_card?)
    end

    def test_order
      expected_orders = [11]
      assert_equal expected_orders, @card_value_objects.map(&:order)
    end

    def test_blackjack_rank
      expected_blackjack_ranks = ['a']
      assert_equal expected_blackjack_ranks, @card_value_objects.map(&:blackjack_rank)
    end

    def test_scores
      expected_scores = [[1, 10]]
      assert_equal expected_scores, @card_value_objects.map(&:scores)
    end
  end
end
