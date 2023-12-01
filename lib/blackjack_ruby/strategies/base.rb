module BlackjackRuby
  module Strategies
    class Base
      attr_reader :dealer_up_card, :player_hand, :strategies

      def initialize(dealer_up_card, player_hand)
        @dealer_up_card = dealer_up_card
        @player_hand = player_hand
        @strategies = build_strategies
      end

      def build_strategies
        raise 'Undefined'
      end

      def dealer_up_card_rank
        @dealer_up_card_rank ||=
          begin
            up_card_value = Models::CardValue.new(dealer_up_card)
            up_card_value.face_card_or_ten_card? ? '10' : up_card_value.rank
          end
      end
    end
  end
end