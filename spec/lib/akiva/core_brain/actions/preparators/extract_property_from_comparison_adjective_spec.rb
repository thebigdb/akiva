require "spec_helper"

describe "Akiva CoreBrain Actions Preparator extract_property_from_comparison_adjective" do
  it "updates the response correctly" do
    proc = Akiva::Brain.actions[:extract_property_from_comparison_adjective]
    response = {filter_captures: {"comparison_adjective" => "heavier"}}
    proc.call(response)

    response.should include(defined_properties: ["weight"])
  end
end