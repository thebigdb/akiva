module Akiva
  class Question
    attr_reader :content, :filter_matched, :filter_captures, :response

    def initialize(content, meta = {})
      @content = content
      @ran_filters = @executed_action = @executed_formatter = false
      @anonymous_action = AnonymousAction.new
      @response = {}
    end

    def run_filters
      return self if @ran_filters

      Akiva::Brain.filters.each do |filter|
        if match_data = filter[:regex].match(@content)
          @filter_matched = filter
          @filter_captures = Hash[match_data.names.zip(match_data.captures)]
          break
        end
      end

      @ran_filters = true
      self
    end

    def execute_action
      return self if @executed_action or @filter_matched.nil?

      actions_chain = (@filter_matched[:before_action] || []) + [@filter_matched[:action]] + (@filter_matched[:after_action] || []) 

      @response.merge!(filter_matched: @filter_matched, filter_captures: @filter_captures, formatter: @filter_matched[:formatter], actions_chain: actions_chain)

      actions_chain.each do |action_name|
        if action = Akiva::Brain.actions[action_name]
          if action.is_a?(Proc)
            @anonymous_action.instance_exec(@response, &action)
          else
            @response = action.process(@response)
          end
        else
          raise "The action #{action_name} isn't registered"
        end
      end

      @executed_action = true
      self
    end

    def execute_formatter
      return self if @executed_formatter

      if @response[:formatter]
        if formatter = Akiva::Brain.formatters[@response[:formatter]]
          if formatter.is_a?(Proc)
            @anonymous_action.instance_exec(@response, &formatter)
          else
            @response = formatter.process(@response)
          end
        else
          raise "The formatter #{@response[:formatter]} isn't registered"
        end
      end

      @executed_formatter = true
      self
    end

    def process
      # shortcut method
      run_filters
      execute_action
      execute_formatter

      self
    end

    def formatted_response
      # shortcut method
      process
      @response[:formatted]
    end


    class AnonymousAction; end

  end
end