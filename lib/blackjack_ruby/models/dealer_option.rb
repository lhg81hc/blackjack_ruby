# frozen_string_literal: true

module BlackjackRuby
  module Models
    class DealerOption
      extend Forwardable

      attr_reader :dealer_hand

      def initialize(dealer_hand)
        @dealer_hand = dealer_hand
      end

      def_delegators :@dealer_hand, :blackjack?, :bust?, :enough?

      def options
        {
          'stay' => can_stay?
        }
      end

      def can_stay?
        blackjack? || bust? || enough?
      end
    end
  end
end
