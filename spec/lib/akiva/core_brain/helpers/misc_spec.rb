require "spec_helper"

describe "Akiva CoreBrain Helpers Misc" do
  describe "degroup_multiple_values" do
    it "correctly works with « width »" do
      a = Akiva::Brain::Helpers.degroup_multiple_values("width")
      a.should == ["width"]
    end

    it "correctly works with « width and height »" do
      a = Akiva::Brain::Helpers.degroup_multiple_values("width and height")
      a.should == ["width", "height"]
    end

    it "correctly works with « width, height and weight »" do
      a = Akiva::Brain::Helpers.degroup_multiple_values("width, height and weight")
      a.should == ["width", "height", "weight"]
    end

    it "correctly works with « the X, an Y and a Z »" do
      a = Akiva::Brain::Helpers.degroup_multiple_values("the X, an Y and a Z")
      a.should == ["X", "Y", "Z"]
    end
  end

end