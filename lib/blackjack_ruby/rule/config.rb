# frozen_string_literal: true

require 'blackjack_ruby/config/option'
# require 'blackjack_ruby/config/params'
require 'blackjack_ruby/rule/dealer_hand'
require 'blackjack_ruby/rule/hand_comparison'
require 'blackjack_ruby/rule/player_hand'

module BlackjackRuby
  module Rule
    class Config
      class Builder
        attr_reader :config

        def initialize(config = Config.new, &block)
          @config = config
          if block_given?
            puts 'block given!!!!'
            instance_eval(&block)
          end
        end

        def build
          @config.validate! if @config.respond_to?(:validate!)
          @config
        end

        def self.builder_class
          Builder
        end

        extend BlackjackRuby::Config::Option

        option :dealer_hits_on_soft_seventeen,  default: BlackjackRuby::Rule::DealerHand::HIT_ON_SOFT_SEVENTEEN
        option :five_card_charlie,              default: BlackjackRuby::Rule::HandComparison::FIVE_CARD_CHARLIE
        option :player_bj_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_BJ_WINS_AUTOMATICALLY
        option :player_21_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_21_WINS_AUTOMATICALLY
        option :blackjack_payout_odds,          default: BlackjackRuby::Rule::PlayerHand::BLACKJACK_PAYOUT_ODDS
        option :maximum_cards_allow_double,     default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_CARDS_ALLOW_DOUBLE
        option :maximum_double_per_betting_box, default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_DOUBLE_PER_BETTING_BOX
      end

      # ACCEPTED_CONFIGURATIONS = {
      #   dealer_hits_on_soft_seventeen: BlackjackRuby::Rule::DealerHand::HIT_ON_SOFT_SEVENTEEN,
      #   five_card_charlie: BlackjackRuby::Rule::HandComparison::FIVE_CARD_CHARLIE,
      #   player_bj_wins_automatically: BlackjackRuby::Rule::HandComparison::PLAYER_BJ_WINS_AUTOMATICALLY,
      #   player_21_wins_automatically: BlackjackRuby::Rule::HandComparison::PLAYER_21_WINS_AUTOMATICALLY,
      #   blackjack_payout_odds: BlackjackRuby::Rule::PlayerHand::BLACKJACK_PAYOUT_ODDS,
      #   maximum_cards_allow_double: BlackjackRuby::Rule::PlayerHand::MAXIMUM_CARDS_ALLOW_DOUBLE,
      #   maximum_double_per_betting_box: BlackjackRuby::Rule::PlayerHand::MAXIMUM_DOUBLE_PER_BETTING_BOX
      # }
      #
      # def initialize(params = {})
      #   BlackjackRuby::Config::Params.new(params).permit(ACCEPTED_CONFIGURATIONS.keys)
      #   @params = params
      #
      #   params.each do |k, v|
      #     instance_variable_set(":@#{k}", v)
      #   end
      # end
      #
      # ACCEPTED_CONFIGURATIONS.each do |attribute, default|
      #   define_method attribute do |*_args|
      #     if instance_variable_defined?(:"@#{attribute}")
      #       instance_variable_get(:"@#{attribute}")
      #     else
      #       default
      #     end
      #   end
      # end

      # def access_token
      #   ::JWT.encode({ iss: @api_key, exp: Time.now.to_i + @timeout }, @api_secret, 'HS256', { typ: 'JWT' })
      # end
      # class Builder
      #   attr_reader :config
      #
      #   def initialize(config = Config.new, &block)
      #     @config = config
      #     if block_given?
      #       puts 'block given!!!!'
      #       instance_eval(&block)
      #     end
      #   end
      #
      #   def build
      #     @config.validate! if @config.respond_to?(:validate!)
      #     @config
      #   end
      #
      #   def self.builder_class
      #     Builder
      #   end
      #
      #   extend BlackjackRuby::Config::Option
      #
      #   option :dealer_hits_on_soft_seventeen,  default: BlackjackRuby::Rule::DealerHand::HIT_ON_SOFT_SEVENTEEN
      #   option :five_card_charlie,              default: BlackjackRuby::Rule::HandComparison::FIVE_CARD_CHARLIE
      #   option :player_bj_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_BJ_WINS_AUTOMATICALLY
      #   option :player_21_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_21_WINS_AUTOMATICALLY
      #   option :blackjack_payout_odds,          default: BlackjackRuby::Rule::PlayerHand::BLACKJACK_PAYOUT_ODDS
      #   option :maximum_cards_allow_double,     default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_CARDS_ALLOW_DOUBLE
      #   option :maximum_double_per_betting_box, default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_DOUBLE_PER_BETTING_BOX
      # end
    end
  end
end
