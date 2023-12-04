module BlackjackRuby
  module Rule
    class PlayerHand
      def blackjack_payout_odds
        (3 / 2).to_f
      end

      def maximum_cards_allow_doubling
        3
      end

      def maximum_doubling_per_betting_box
        2
      end
    end
  end
end
