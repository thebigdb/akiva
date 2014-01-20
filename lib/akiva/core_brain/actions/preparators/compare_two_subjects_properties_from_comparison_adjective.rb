Akiva::Brain.update do

  add_action :compare_two_subjects_properties_from_comparison_adjective do |response|
    answers_values = response[:answers].map{|hash| hash.last.first.last }

    begin
      units = Akiva::Brain::Helpers::Units.new(answers_values)
      units.compare # in the future, you may want to pass a multiplicator here
    rescue
      # we fail silently for now, as the error probably comes from the data in TheBigDB anyway,
      # which could well be invalid (= not convertible units)
    else
      property_comparator = Akiva::Brain::Helpers::ComparisonAdjectivesToProperties[response[:filter_captures]["comparison_adjective"]][:comparator]
      response[:comparison_boolean_result] = (units.result == property_comparator)
    end # begin

  end

end
