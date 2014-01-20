Akiva::Brain.update do

  add_action :get_answers_from_subjects_and_properties do |response|

    # It's possible we're arriving here with already defined subjects and properties, in that case, skip the default request
    unless response[:defined_subjects] and response[:defined_properties]
      regex_matched_subjects = response[:filter_captures]["subjects"]
      regex_matched_properties = response[:filter_captures]["properties"]

      # First, we try the obvious subject x property, works if there's only one subject and one property
      search = TheBigDB.search(subject: regex_matched_subjects, property: regex_matched_properties).with(per_page: 1)

      if search["total_results"] == 1
        statement = search["statements"].first
        response[:subjects] = [statement["nodes"]["subject"]]
        response[:properties] = {statement["nodes"]["subject"] => [statement["nodes"]["property"]]}
        response[:answers] = {statement["nodes"]["subject"] => {statement["nodes"]["property"] => statement["nodes"]["answer"]}}

        next # we're happy with what we have, no need to continue the action.
      end

      # If we don't have an obvious answer, it may be because we're searching for multiple subjects and/or properties
      degrouped_subjects = Akiva::Brain::Helpers.degroup_multiple_values(regex_matched_subjects)
      degrouped_properties = Akiva::Brain::Helpers.degroup_multiple_values(regex_matched_properties)

      if degrouped_subjects.size == 1 and degrouped_properties.size == 1
        next # sadly we don't have anything to further analyze/search for, so we're exiting the action empty-handed.
      end

      # Let's make products of elements to be sure we're not missing anything
      products_mega_groups = []
      products_mega_groups << [regex_matched_subjects].product(degrouped_properties)
      products_mega_groups << degrouped_subjects.product([regex_matched_properties])
      products_mega_groups << degrouped_subjects.product(degrouped_properties)
      products_mega_groups.uniq!
    else
      products_mega_groups = [response[:defined_subjects].product(response[:defined_properties])]
    end

    products_mega_groups.each do |product_mega_group|
      statements_compiled = {}
      statements_found = 0

      product_mega_group.each do |group|
        search = TheBigDB.search(subject: group[0], property: group[1]).with(per_page: 1)
        if search["total_results"] == 1
          statements_found += 1
          statement = search["statements"].first
          statements_compiled[group[0]] ||= {}
          statements_compiled[group[0]][group[1]] = statement["nodes"]["answer"]
        else
          break # if one is missing, we exit this each block since we're looking for a perfect product results
        end
      end

      if statements_found == product_mega_group.size
        response[:subjects] = statements_compiled.keys
        response[:properties] = {}
        statements_compiled.each_pair do |k, v|
          response[:properties][k] = v.keys
        end
        response[:answers] = statements_compiled

        break # we're happy with what we have, no need to continue mega_groups each-block.
      end
    end




  end

end