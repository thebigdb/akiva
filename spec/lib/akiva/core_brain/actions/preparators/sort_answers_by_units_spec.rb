require "spec_helper"

describe "Akiva CoreBrain Actions Preparator sort_answers_by_units" do
  it "updates the response correctly" do
    proc = Akiva::Brain.actions[:sort_answers_by_units]
    response = {answers: {"subject1" => {"property" => "112 grams"}, "subject2" => {"property" => "2 kg"}, "subject3" => {"property" => "10 g"}}}
    proc.call(response)

    response.should include(sorted_answers_by_units: [
      {
        "subject3" => {
          "property" => {
            value: "10 g",
            # value_with_adjusted_unit: nil
          }
        }
      },
      {
        "subject1" => {
          "property" => {
            value: "112 g",
            # value_with_adjusted_unit: nil
          }
        }
      },
      {
        "subject2" => {
          "property" => {
            value: "2 kg",
            # value_with_adjusted_unit: nil
          }
        }
      }
    ])
  end
end