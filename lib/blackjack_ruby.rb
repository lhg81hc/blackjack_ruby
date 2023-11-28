# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

require 'blackjack_ruby/version'
require 'blackjack_ruby/models/shoe'
require 'blackjack_ruby/models/card_value'
require 'blackjack_ruby/models/play'
require 'blackjack_ruby/models/hand'

module BlackjackRuby
  class Error < StandardError; end
  # Your code goes here...
end
