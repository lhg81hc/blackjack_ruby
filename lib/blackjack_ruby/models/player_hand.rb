module BlackjackRuby
  module Models
    class PlayerHand < Hand
      # 0 => 'Stay'
      # 1 => 'Hit'
      def options
        if must_stay?
          return [0]
        end

        if must_hit?
          return [1]
        end

        if hit_or_stay?
          return [0, 1]
        end

        raise "Unknown known hand: #{cards.map(&:to_encoded_unicode).join(' ')}"
      end

      # def enough?
      #   scores.any? { |s| s >= 12 && s <= 21 }
      # end

      def hit_or_stay?
        !blackjack? && scores.any? { |s| s < 21 }
      end

      def must_hit?
        !blackjack? && scores.all? { |s| s < 12 }
      end

      def must_stay?
        blackjack? || busted? || twenty_one?
      end

      def twenty_one?
        !blackjack? && scores.any? { |s| s == 21 }
      end

      def only_one_option?
        options.count == 1
      end
    end
  end
end
