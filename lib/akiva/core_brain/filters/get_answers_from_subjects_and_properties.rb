Akiva::Brain.update do
  # The priority is based upon order of creation: last created -> highest priority.

  add_filter :get_answers_from_subjects_and_properties,
    /\A(?:What (?:is|are)|What's) the (?<properties>.+?) of (?:a |an |the )?(?<subjects>.+?)(?: \?)?\z/i,
    formatter: :list_all_answers

  add_filter :get_answers_from_subjects_and_properties,
    /\AIs (?<subject1>.+?) (?<comparison_adjective>(#{Akiva::Brain::Helpers::ComparisonAdjectivesToProperties.keys.join("|")})?) than (?<subject2>.+?)(?: \?)?\z/i,
    before_action: [:regroup_separated_subjects, :extract_property_from_comparison_adjective],
    after_action: [:compare_two_subjects_properties_from_comparison_adjective],
    formatter: :boolean_from_comparison


end