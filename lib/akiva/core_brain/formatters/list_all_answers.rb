Akiva::Brain.update do

  add_formatter :list_all_answers do |response|
    
    describe_properties = lambda do |subject|
      if (properties = response[:properties][subject]).size == 1 # if there is only one property
        response[:answers][subject][properties.first]
      else # if there are multiple properties
        answers = response[:answers][subject].values
        properties.map.with_index do |property, i|
          property.capitalize + ": " + answers[i]
        end.join(", ")
      end
    end

    if response[:subjects]
      if response[:subjects].size == 1 # if there's only one subject
        response[:formatted] = describe_properties.call(response[:subjects].first)
      else # if there are multiple subjects
        response[:formatted] = response[:subjects].map do |subject|
          subject + " => " + describe_properties.call(subject)
        end.join("; ")
      end
    end
    
  end

end