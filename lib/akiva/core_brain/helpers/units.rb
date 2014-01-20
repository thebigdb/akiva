module Akiva
  module Brain
    module Helpers
      class Units
        class UnitNotRecognizedError < StandardError; end
        class IncompatibleUnitsError < StandardError; end
        class TooLongToInstantiateError < StandardError; end
        class NeedTwoValuesToCompareError < StandardError; end
        class CantCompareMoreThanTwoValuesError < StandardError; end
        class InputMustBeAnArray < StandardError; end

        attr_reader :input, :result, :instantiated_values, :first_value, :last_value

        def initialize(input)
          @input = input
        end

        def compare(options = {})
          check_presence_of_values
          check_type_of_values
          check_length_of_values_for_comparison
          instantiate_values
          check_compatibility_of_units

          @first_value = @instantiated_values.first
          @last_value = @instantiated_values.last

          if multiplicators = options[:multiplicators]
            @first_value = (@first_value * multiplicators[0]) if multiplicators[0]
            @last_value = (@last_value * multiplicators[1]) if multiplicators[1]
          end

          @first_value, @last_value = self.class.adjust_units(@first_value, @last_value)

          if @first_value > @last_value
            @result = "superior"
          elsif @first_value < @last_value
            @result = "inferior"
          else
            @result = "equal"
          end
        end

        def sort
          check_presence_of_values
          check_type_of_values
          check_maximum_length_of_values
          instantiate_values
          check_compatibility_of_units

          @result = @instantiated_values.sort
        end

        def convert(new_unit = "")
          instantiate_values

          begin
            new_instantiated_value = @instantiated_value.convert_to(new_unit)
            @result = new_instantiated_value.scalar.to_f.to_s
            @result = @result[0..@result.size-3] if @result.match(/\.0$/) # 135.0 => 135
          rescue ArgumentError => error_string
            if error_string.to_s.include?("Unit not recognized") or error_string.to_s.include?("No Unit Specified")
              raise UnitNotRecognizedError
            elsif error_string.to_s.include?("Incompatible Units")
              raise IncompatibleUnitsError
            else
              raise
            end
          end
        end


        def self.adjust_units(value_1, value_2)
          if ((value_1.to_s.include?("e+") or value_1.to_s.include?("e-")) and (!value_2.to_s.include?("e+") and !value_2.to_s.include?("e-"))) or value_1.scalar.to_s.size > value_2.scalar.to_s.size
            value_1 = value_1.convert_to(value_2)
          elsif ((!value_1.to_s.include?("e+") and !value_1.to_s.include?("e-")) and (value_2.to_s.include?("e+") or value_2.to_s.include?("e-"))) or value_1.scalar.to_s.size < value_2.scalar.to_s.size
            value_2 = value_2.convert_to(value_1)
          end

          [value_1, value_2]
        end

        private
        def check_presence_of_value
          if @input.nil?
            raise NeedTwoValuesToCompareError
          end
        end

        def check_presence_of_values
          if @input.nil?
            raise NeedTwoValuesToCompareError
          end
        end

        def check_type_of_values
          unless @input.is_a?(Array) or @input.is_a?(Hash)
            raise InputMustBeAnArray
          end
        end

        def check_length_of_values_for_comparison
          if @input.size < 2
            raise NeedTwoValuesToCompareError
          elsif @input.size > 2
            raise CantCompareMoreThanTwoValuesError
          end
        end

        def check_maximum_length_of_values
          if @input.size > 100
            raise CantCompareMoreThanTwoValuesError
          end
        end

        def instantiate_values
          # we accept strings here specially for the "convert" action
          # everywhere else it is filtered with check_type_of_values

          if @input.is_a?(String)
            values_strings = [@input]
          elsif @input.is_a?(Hash)
            values_strings = @input.values
          else
            values_strings = @input
          end

          begin
            # we check how much time it takes because it can be REALLY slow be big textual values
            # e.g. "900000000000000000000000000000000000 meters" took 5secs to instantiate (!)
            Timeout::timeout(0.1) do
              if @input.is_a?(String)
                @instantiated_value = Unit(@input)
              elsif values_strings.is_a?(Array)
                @instantiated_values = values_strings.map{|_| Unit(_) }
              end
            end
          rescue Timeout::Error
            raise CantCompareMoreThanTwoValuesError
            return false
          rescue ArgumentError => error_string
            if error_string.to_s.include?("Unit not recognized")
              raise UnitNotRecognizedError
              return false
            else
              raise # error unknown
            end
          end
        end

        def check_compatibility_of_units
          # we simply check if it can be sorted
          begin
            @instantiated_values.sort
          rescue ArgumentError => error_string
            if error_string.to_s.include?("Incompatible Units")
              raise IncompatibleUnitsError.new(error_string)
            else
              raise
            end
          end
        end

      end
    end
  end
end