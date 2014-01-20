require "spec_helper"

describe "Akiva CoreBrain Actions Preparator compare_two_subjects_properties_from_comparison_adjective" do
  it "updates the response correctly" do
    proc = Akiva::Brain.actions[:compare_two_subjects_properties_from_comparison_adjective]
    response = {
      filter_captures: {"comparison_adjective" => "heavier"},
      answers: {"subject1" => {"property" => "112 grams"}, "subject2" => {"property" => "2 kg"}}
    }
    proc.call(response)

    response.should include(comparison_boolean_result: false)

    response = {
      filter_captures: {"comparison_adjective" => "heavier"},
      answers: {"subject1" => {"property" => "112 grams"}, "subject2" => {"property" => "111 g"}}
    }
    proc.call(response)

    response.should include(comparison_boolean_result: true)
  end
end