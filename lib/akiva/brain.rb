module Akiva
  module Brain
    @@filters = []
    @@actions = {}
    @@formatters = {}

    class << self
      def update(&block)
        instance_exec(&block)
      end

      def empty
        @@filters = []
        @@actions = {}
        @@formatters = {}
      end

      def add_filter(action_name, regex, options = {})
        @@filters.unshift({
          regex: regex,
          action: action_name
        }.merge(options))
      end

      def add_action(action_name, class_instance = nil, &block)
        @@actions[action_name] = class_instance || block
      end

      def add_formatter(formatter_name, class_instance = nil, &block)
        @@formatters[formatter_name] = class_instance || block
      end

      # readers
      def filters
        @@filters
      end

      def actions
        @@actions
      end

      def formatters
        @@formatters
      end
    end
  end
end