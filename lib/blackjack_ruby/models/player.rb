module BlackjackRuby
  module Models
    class Player
      INITIAL_RESULT = 'Not Played'

      attr_reader :hands

      def initialize(hands)
        @hands = hands
      end

      def split(hand_index)
        hand = hands.delete_at(hand_index)

        raise 'Hand not found' unless hand
        raise 'Hand is invalid to split' unless hand.options['split']

        new_hands =
          hand.cards.map do |card|
            new_hand = PlayerHand.new([card])
            new_hand.bet = hand.bet
            new_hand
          end

        new_hands.each_with_index do |new_hand, index|
          hands.insert(hand_index + index, new_hand)
        end
      end

      def double(hand)
        raise 'Hand is invalid to double' unless hand.options['double']
      end
    end
  end
end
