Akiva::Brain.update do

  add_action :regroup_separated_subjects do |response|
    response[:defined_subjects] ||= []
    response[:filter_captures].each_pair do |name, capture|
      response[:defined_subjects] << Akiva::Brain::Helpers.cleanup_articles(capture) if name =~ /\Asubject\d+/
    end
  end

end