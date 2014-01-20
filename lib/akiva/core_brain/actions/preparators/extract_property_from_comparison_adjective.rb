Akiva::Brain.update do

  add_action :extract_property_from_comparison_adjective do |response|

    # Note: for now, we're only working with the first property listed for the adjective
    response[:defined_properties] = [Akiva::Brain::Helpers::ComparisonAdjectivesToProperties[response[:filter_captures]["comparison_adjective"]][:properties].first]

  end

end