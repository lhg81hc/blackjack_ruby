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
        {}
        # raise 'Undefined'
      end

      def dealer_up_card_rank
        @dealer_up_card_rank ||= Models::CardValue.new(dealer_up_card).blackjack_rank
      end

      def player_card_ranks
        @player_card_ranks ||=
          player_hand.card_values.sort_by(&:order).reverse.map(&:blackjack_rank).join(',')
      end
    end
  end
end
