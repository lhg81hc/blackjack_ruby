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

        hand.cards.map.with_index do |card, index|
          new_hand = PlayerHand.new([card])
          new_hand.bet = hand.bet

          hands.insert(hand_index + index, new_hand)
        end
      end

      def double(hand_index)
        hand = hands[hand_index]

        raise 'Hand not found' unless hand
        raise 'Hand is invalid to double' unless hand.options['double']

        hand.bet = hand.bet * 2
        hand.doubled = true
      end

      def stay(hand_index)
        hand = hands[hand_index]
        raise 'Hand not found' unless hand

        hand.stayed = true
      end
    end
  end
end
