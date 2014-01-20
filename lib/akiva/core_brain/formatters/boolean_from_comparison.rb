Akiva::Brain.update do
  
  add_formatter :boolean_from_comparison do |response|
    if response.has_key?(:comparison_boolean_result)
      if response[:comparison_boolean_result]
        response[:formatted] = "Yes"
      else
        response[:formatted] = "No"
      end

      if response.has_key?(:actions_chain) and response[:actions_chain].include?(:compare_two_subjects_properties_from_comparison_adjective)
        response[:formatted] += " (#{Akiva::Brain.formatters[:list_all_answers].call(response)})"
      end
    end
  end

end