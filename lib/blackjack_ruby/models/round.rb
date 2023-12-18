# frozen_string_literal: true

module BlackjackRuby
  module Models
    class Round
      extend Forwardable

      attr_reader :shoe_of_cards, :betting_boxes

      def initialize(shoe_of_cards, betting_boxes)
        @shoe_of_cards = shoe_of_cards
        @betting_boxes = betting_boxes
      end

      def start
        validate_shoe_of_cards
        validate_betting_boxes
        # deal card for each hand in each betting boxes
        # evaluate the result on each hand of betting box
        # pay out the winning hands
        # deal card for dealer
        # compare dealer hand with the remaining player hands
      end

      def validate_shoe_of_cards
        raise 'Shoe can not be blank' unless shoe_of_cards
      end

      def validate_betting_boxes
        raise 'Betting boxes can not be blank' unless betting_boxes.any?

        betting_boxes.each do |betting_box|
          raise 'Betting box much contains player hand' unless betting_box.player_hands.any?
        end
      end

      def deal_player_cards
        betting_boxes.each do |betting_box|
          betting_box.deal_initial_hand([shoe.draw, shoe.draw])
        end
      end
      # def_delegators :@list, :count, :shuffle!, :shift, :pop, :empty?
    end
  end
end
