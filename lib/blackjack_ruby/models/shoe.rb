# frozen_string_literal: true

require 'deck_of_cards_ruby'

module BlackjackRuby
  module Models
    # Represent a shoe which can have multiple deck of cards
    class Shoe
      extend Forwardable

      attr_reader :list, :number_of_decks

      def initialize(number_of_decks: 2)
        @number_of_decks = number_of_decks
        @list = generate_shoe
      end

      def_delegators :@list, :count, :shuffle!, :shift, :pop, :empty?

      def remaining
        @list
      end

      def draw(draw_position = 'top')
        case draw_position
        when 'top'
          shift
        when 'bottom'
          pop
        else
          raise "Invalid 'draw position' argument"
        end
      end

      def take_cards(number_of_cards = 1)
        raise "Must take at least 1 card" if number_of_cards < 1

        Array.new(number_of_cards) { take_a_card }
      end

      def take_a_card
        return nil if empty?

        idx = Random.new.rand(count)
        idx && @list.delete_at(idx)
      end

      def pick(rank, suit)
        return nil if empty?

        wanted = DeckOfCardsRuby::Card.new(rank, suit)
        idx = @list.index { |c| c.rank.to_s == wanted.rank.to_s && c.suit.to_s == wanted.suit.to_s }
        idx && @list.delete_at(idx)
      end

      private

      def generate_shoe
        raise "Shoe must contain at least one deck of card" if number_of_decks < 1

        Array.new(number_of_decks, DeckOfCardsRuby::Deck.new.remaining).flatten
      end
    end
  end
end
