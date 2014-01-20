require "spec_helper"

describe "Akiva CoreBrain Actions Preparator regroup_separated_subjects" do
  it "updates the response correctly" do
    proc = Akiva::Brain.actions[:regroup_separated_subjects]
    response = {filter_captures: {"subject1" => "the iPhone 5s", "subject2" => "a Galaxy S4", "something_else" => "foobar"}}
    proc.call(response)

    response.should include(defined_subjects: ["iPhone 5s", "Galaxy S4"])
  end
end