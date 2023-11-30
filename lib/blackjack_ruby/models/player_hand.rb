module BlackjackRuby
  module Models
    class PlayerHand < Hand

      def options
        {
          'hit' => can_hit?,
          'split' => can_split?,
          'stay' => true,
        }

      end

      def can_split?
        two_cards? && identical_score_cards?
      end

      def can_hit?
        !blackjack? && scores.any? { |s| s < Hand::BUST_VALUE }
      end
    end
  end
end
