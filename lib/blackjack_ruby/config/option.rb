# frozen_string_literal: true

module BlackjackRuby
  class Config
    # Rule configuration options
    module Option
      def option(name, options = {})
        attribute = options[:as] || name

        builder_class.instance_eval do
          if method_defined?(name)
            remove_method name
          end

          define_method name do |*args, &block|
            value = block || args.first
            @config.instance_variable_set(:"@#{attribute}", value)
          end
        end

        define_method attribute do |*_args|
          if instance_variable_defined?(:"@#{attribute}")
            instance_variable_get(:"@#{attribute}")
          else
            options[:default]
          end
        end

        public attribute
      end

      def self.extended(base)
        return if base.respond_to?(:builder_class)

        raise "Define `self.builder_class` method " \
          "for #{base} that returns your custom Builder class to use options DSL!"
      end
    end
  end
end
