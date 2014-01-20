require "spec_helper"

describe "Akiva CoreBrain Formatter boolean_from_comparison" do
  it "updates the response correctly" do
    proc = Akiva::Brain.formatters[:boolean_from_comparison]
    response = {
      comparison_boolean_result: true
    }
    proc.call(response)

    response[:formatted].should == "Yes"

    response = {
      comparison_boolean_result: false
    }
    proc.call(response)

    response[:formatted].should == "No"
  end


  describe "with the action compare_two_subjects_properties_from_comparison_adjective among the list called" do
    it "updates the response correctly" do
      proc = Akiva::Brain.formatters[:boolean_from_comparison]
      response = {
        actions_chain: [:compare_two_subjects_properties_from_comparison_adjective],
        comparison_boolean_result: false,
        subjects: ["iPhone 5s", "Galaxy S4"],
        properties: {"iPhone 5s" => ["weight"], "Galaxy S4" => ["weight"]},
        answers: {"iPhone 5s" => {"weight" => "112 grams"}, "Galaxy S4" => {"weight" => "130 grams"}}
      }
      proc.call(response)

      response[:formatted].should == "No (iPhone 5s => 112 grams; Galaxy S4 => 130 grams)"
    end
  end

end
