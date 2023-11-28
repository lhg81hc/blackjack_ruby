module BlackjackRuby
  module Models
    class CardValue
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def face_card?
        ['10', 'j', 'q', 'k'].include?(rank)
      end

      def ace_card?
        rank == 'a'
      end

      def rank
        @rank ||= card.rank.val
      end

      def scores
        if face_card?
          [10]
        elsif ace_card?
          [1, 11]
        else
          [rank.to_i]
        end
      end
    end
  end
end
