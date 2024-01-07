module BlackjackRuby
  module Rule
    class PlayerHand
      BLACKJACK_PAYOUT_ODDS = 2
      MAXIMUM_CARDS_ALLOW_DOUBLE = 3
      MAXIMUM_SPLITTING_PER_BETTING_BOX = 2
      PLAYER_SURRENDERS_VERSUS_2_to_9 = false
      PLAYER_SURRENDERS_VERSUS_10 = 'early'
      PLAYER_SURRENDERS_VERSUS_ACE = 'early'
    end
  end
end
