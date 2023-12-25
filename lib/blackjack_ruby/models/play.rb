module BlackjackRuby
  module Models
    class Play
      def init_new_shoe(shuffle: true)
        @shoe = Shoe.new(number_of_decks: BlackjackRuby.config.number_of_decks)
        @shoe.shuffle! if shuffle
      end

      def init_betting_boxes(boxes)
        @betting_boxes = boxes.map { |box_attributes| BlackjackRuby::Models::BettingBox.new(**box_attributes) }
      end

      def setup_new_round
        @round = BlackjackRuby::Models::Round.new(shoe_of_cards: @shoe, betting_boxes: @betting_boxes)

        @round.setup
        @dealer_hand = @round.dealer_hand
      end

      def auto(number_of_games: 1)
        total_blackjack_count = 0
        dealer_soft_seventeen_count = 0
        dealer_win_count = 0
        player_win_count = 0
        player_win_with_bj_count = 0
        player_win_with_5_card_count = 0
        tie_with_bj_on_both = 0
        tie_count = 0

        sum = 0

        (1..number_of_games).each do |_n|
          init_new_shoe
          init_betting_boxes([{ index: 0, bet: 1 }])
          setup_new_round

          @round.betting_boxes.each do |betting_box|
            idx = 0
            while idx < betting_box.total_hands
              player_hand = betting_box.player_hands[idx]
              move = Strategies::Finder.new(@dealer_hand.up_card, player_hand).find_move

              case move
              when 'Split'
                betting_box.split(idx)
                next
              when 'Hit'
                betting_box.hit(idx, @shoe.draw)
                next
              when 'Stay'
                idx += 1
                next
              when 'Double'
                if player_hand.can_double?
                  betting_box.double_down(idx)
                end
                player_hand.add_card(@shoe.draw)
                idx += 1
                next
              else
                raise 'Can not find move'
              end
            end

            until @dealer_hand.options['stay']
              @dealer_hand.add_card(@shoe.draw)
            end

            dealer_hand_unicode_str = @dealer_hand.cards.map(&:to_encoded_unicode).join(' ')
            dealer_hand_score_str =
              if @dealer_hand.blackjack?
                total_blackjack_count += 1
                'BJ'
              elsif @dealer_hand.soft_seventeen?
                dealer_soft_seventeen_count += 1
                @dealer_hand.scores.join(' or ')
              else
                @dealer_hand.scores.join(' or ')
              end
            puts dealer_hand_unicode_str
            puts dealer_hand_score_str
            puts '--------'

            str1 =
              betting_box.player_hands.map do |hand|
                hand.cards.map(&:to_encoded_unicode).join(' ')
              end

            puts str1.join('  ')


            str2 =
              betting_box.player_hands.map do |hand|
                if hand.blackjack?
                  total_blackjack_count += 1

                  'BJ'
                else
                  hand.scores.join(' or ')
                end
              end

            str3 =
              betting_box.player_hands.map do |hand|
                c = HandComparison.new(dealer_hand: @dealer_hand, player_hand: hand)
                # c.winner_translation

                win_amount = hand.bet * hand.payout_odds
                lost_amount = hand.bet

                if c.winner_translation == 'Dealer'
                  dealer_win_count += 1
                  sum += (-lost_amount)
                  -lost_amount
                elsif c.winner_translation == 'Player'
                  player_win_count += 1
                  player_win_with_bj_count += 1 if hand.blackjack?
                  player_win_with_5_card_count += 1 if hand.five_card_charlie?

                  sum += win_amount
                  win_amount
                elsif c.winner_translation == 'Tie'
                  tie_count += 1

                  if hand.blackjack?
                    tie_with_bj_on_both += 1
                    win_amount
                  else
                    -lost_amount
                  end
                end

                # c.winner_translation
              end

            puts str2.join(' | ')
            puts str3.join(' | ')
            puts "\n\n"
          end
        end

        # puts "No of Blackjack: #{total_blackjack_count}"
        # puts "No of 1st hand Blackjack: #{first_hand_blackjack_count}"
        # puts "No of Soft Seventeen: #{dealer_soft_seventeen_count}"
        puts "Dealer win: #{dealer_win_count}"
        puts "Player win: #{player_win_count}"
        puts "Player win with BJ: #{player_win_with_bj_count}"
        puts "Player win with 5-card Charlie: #{player_win_with_5_card_count}"
        puts "Tie: #{tie_count}"
        puts "Tie with BJ on both: #{tie_with_bj_on_both}"
        puts "Sum: #{sum}"
      end
    end
  end
end
