module BlackjackRuby
  module Models
    #Representing and evaluating the value of a card in a blackjack game
    class CardValue
      MAP =
        {
          '2' => { scores: [2], blackjack_rank: '2', face_card_or_ten_card: false, order: 0 },
          '3' => { scores: [3], blackjack_rank: '3', face_card_or_ten_card: false, order: 1 },
          '4' => { scores: [4], blackjack_rank: '4', face_card_or_ten_card: false, order: 2 },
          '5' => { scores: [5], blackjack_rank: '5', face_card_or_ten_card: false, order: 3 },
          '6' => { scores: [6], blackjack_rank: '6', face_card_or_ten_card: false, order: 4 },
          '7' => { scores: [7], blackjack_rank: '7', face_card_or_ten_card: false, order: 5 },
          '8' => { scores: [8], blackjack_rank: '8', face_card_or_ten_card: false, order: 6 },
          '9' => { scores: [9], blackjack_rank: '9', face_card_or_ten_card: false, order: 7 },
          '10' => { scores: [10], blackjack_rank: '10', face_card_or_ten_card: true, order: 8 },
          'j' => { scores: [10], blackjack_rank: '10', face_card_or_ten_card: true, order: 9 },
          'q' => { scores: [10], blackjack_rank: '10', face_card_or_ten_card: true, order: 10 },
          'k' => { scores: [10], blackjack_rank: '10', face_card_or_ten_card: true, order: 10 },
          'a' => { scores: [1, 10], blackjack_rank: 'a', face_card_or_ten_card: false, order: 11 },
        }.freeze

      ACE_RANK = 'a'.freeze

      attr_reader :card

      def initialize(card)
        @card = card

        validate
      end

      def rank
        card.rank.val
      end

      def ace_card?
        rank == ACE_RANK
      end

      def face_card_or_ten_card?
        MAP[rank].fetch(:face_card_or_ten_card) == true
      end

      def order
        val = MAP.dig(rank, :order)
        raise 'Unknown rank' unless val

        val
      end

      def blackjack_rank
        val = MAP.dig(rank, :blackjack_rank)
        raise 'Unknown rank' unless val

        val
      end

      def scores
        val = MAP.dig(rank, :scores)
        raise 'Unknown rank' unless val

        val
      end

      def best_score
        scores.max
      end

      private

      def validate
        raise 'Invalid rank' unless MAP.keys.include?(rank)
      end
    end
  end
end
