Akiva::Brain.update do

  add_action :sort_answers_by_units do |response|
    # This is supposed to sort one answer for one property for multiple subjects,
    # you may want to create another action to do something more.

    answers_values = response[:answers].map{|hash| hash.last.first.last }

    begin
      units = Akiva::Brain::Helpers::Units.new(answers_values)
      units.sort
    rescue
      # we fail silently for now, as the error probably comes from the data in TheBigDB anyway,
      # which could well be invalid (= not convertible units)
    else
      response[:sorted_answers_by_units] = []
      units.result.each do |instantiated_value|
        response[:answers].each do |hash|
          if instantiated_value == hash.last.first.last
            response[:sorted_answers_by_units] <<
              {
                hash.first => {
                  hash.last.first.first => {
                    value: instantiated_value.to_s
                  }
                }
              }
          end
        end
      end
    end # begin

  end

end