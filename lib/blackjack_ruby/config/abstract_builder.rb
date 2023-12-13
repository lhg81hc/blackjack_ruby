# frozen_string_literal: true

module BlackjackRuby
  class Config
    # Abstract base class for BlackjackRuby and it's extensions configuration
    # builder. Instantiates and validates gem configuration.
    #
    class AbstractBuilder
      attr_reader :config

      # @param [Class] config class
      #
      def initialize(config = Config.new, &block)
        @config = config
        instance_eval(&block) if block_given?
      end

      # Builds and validates configuration.
      #
      # @return [BlackjackRuby::Config] config instance
      #
      def build
        @config.validate! if @config.respond_to?(:validate!)
        @config
      end
    end
  end
end
