# frozen_string_literal: true

require 'deck_of_cards_ruby'

module BlackjackRuby
  module Models
    class BettingBox
      attr_reader :index, :bet, :player_hands

      def initialize(index: nil, bet: nil)
        @index = index
        @bet = bet
        @player_hands = nil

        validate
      end

      def deal_initial_hand(cards)
        @player_hands ||=
          Array.new(1) do
            new_hand = Hand::PlayerHand.new(cards)
            new_hand.bet = bet
            new_hand.betting_box = self
            new_hand
          end
      end

      def total_hands
        player_hands.nil? ? 0 : player_hands.count
      end

      def split(hand_index)
        hand = find_and_delete_hand!(hand_index)
        raise 'Hand is invalid to split' unless hand.valid_to_split?

        hand.cards.map.with_index do |card, index|
          new_hand = Hand::PlayerHand.new([card])
          new_hand.bet = hand.bet
          new_hand.betting_box = self

          player_hands.insert(hand_index + index, new_hand)
        end
      end

      def double(hand_index)
        hand = find_hand!(hand_index)
        raise 'Hand is invalid to double' unless hand.valid_to_double?

        hand.double
      end

      def stay(hand_index)
        hand = find_hand!(hand_index)
        hand.stayed = true
      end

      def hit(hand_index, new_card)
        hand = find_hand!(hand_index)
        hand.add_card(new_card)
      end

      private

      def validate
        raise 'Index is invalid' unless index.is_a?(Integer) && index >= 0 && index <= 8
        raise 'Bet is invalid' if @bet.nil?
      end

      def find_hand!(hand_index)
        hand = player_hands[hand_index]
        raise 'Hand not found' unless hand

        hand
      end

      def find_and_delete_hand!(hand_index)
        hand = player_hands[hand_index]
        raise 'Hand not found' unless hand

        player_hands.delete_at(hand_index)
      end
    end
  end
end
