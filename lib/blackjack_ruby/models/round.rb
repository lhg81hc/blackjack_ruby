# frozen_string_literal: true

module BlackjackRuby
  module Models
    class Round
      attr_reader :shoe_of_cards, :betting_boxes, :dealer_hand

      def initialize(shoe_of_cards: nil, betting_boxes: [])
        @shoe_of_cards = shoe_of_cards
        @betting_boxes = betting_boxes
        @dealer_hand = nil

        validate_shoe_of_cards
        validate_betting_boxes
      end

      def setup
        deal_player_hands
        deal_dealer_hand
      end

      def validate_shoe_of_cards
        raise 'Shoe can not be blank' unless shoe_of_cards
      end

      def validate_betting_boxes
        raise 'Betting boxes can not be blank' unless betting_boxes.any?
      end

      def deal_player_hands
        betting_boxes.each do |betting_box|
          betting_box.deal_initial_hand([shoe_of_cards.draw, shoe_of_cards.draw])
        end
      end

      def deal_dealer_hand
        raise 'Dealer Hand already dealt' unless dealer_hand.nil?

        @dealer_hand = BlackjackRuby::Hand::DealerHand.new([shoe_of_cards.draw, shoe_of_cards.draw])
      end
    end
  end
end
