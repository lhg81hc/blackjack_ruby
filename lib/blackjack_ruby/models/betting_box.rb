# frozen_string_literal: true

module BlackjackRuby
  module Models
    # Represents a betting box in blackjack table
    class BettingBox
      attr_reader :index, :bet, :player_hands

      def initialize(index: nil, bet: nil)
        @index = index
        @bet = bet
        @player_hands = []

        validate
      end

      def deal_initial_hand(cards)
        raise 'Already dealt the initial hand' if total_hands.positive?

        @player_hands =
          Array.new(1) do
            new_hand = Hand::PlayerHand.new(cards)
            new_hand.bet = bet
            new_hand.betting_box = self
            new_hand
          end
      end

      def total_hands
        player_hands.count
      end

      def split(hand_index)
        hand = find_hand!(hand_index)
        raise 'Hand is invalid to split' unless hand.valid_to_split?

        hand = find_and_delete_hand!(hand_index)
        hand.cards.map.with_index do |card, index|
          new_hand = Hand::PlayerHand.new([card])
          new_hand.bet = hand.bet
          new_hand.split = true
          new_hand.betting_box = self

          player_hands.insert(hand_index + index, new_hand)
        end
      end

      def double_down(hand_index)
        hand = find_hand!(hand_index)
        raise 'Hand is invalid to double' unless hand.valid_to_double?

        hand.double_down
      end

      def stay(hand_index)
        hand = find_hand!(hand_index)
        hand.stayed = true
      end

      def hit(hand_index, new_card)
        hand = find_hand!(hand_index)
        hand.add_card(new_card)
      end

      def surrender(hand_index)
        hand = find_hand!(hand_index)
        hand.surrender
      end

      private

      def validate
        raise 'Index is invalid' unless index.is_a?(Integer) && (0..8).include?(index)
        raise 'Bet is invalid' if @bet.nil? || !@bet.positive?
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
