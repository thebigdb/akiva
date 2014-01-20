require "spec_helper"

describe "Akiva CoreBrain Formatter list_all_answers" do
  describe "with one subject and one property" do
    it "updates the response correctly" do
      proc = Akiva::Brain.formatters[:list_all_answers]
      response = {
        subjects: ["iPhone 5s"],
        properties: {"iPhone 5s" => ["weight"]},
        answers: {"iPhone 5s" => {"weight" => "112 grams"}}
      }
      proc.call(response)

      response[:formatted].should == "112 grams"
    end
  end

  describe "with one subject and multiple properties" do
    it "updates the response correctly" do
      proc = Akiva::Brain.formatters[:list_all_answers]
      response = {
        subjects: ["iPhone 5s"],
        properties: {"iPhone 5s" => ["weight", "height"]},
        answers: {"iPhone 5s" => {"weight" => "112 grams", "height" => "123.8 mm"}}
      }
      proc.call(response)

      response[:formatted].should == "Weight: 112 grams, Height: 123.8 mm"
    end
  end

  describe "with multiple subjects and one property" do
    it "updates the response correctly" do
      proc = Akiva::Brain.formatters[:list_all_answers]
      response = {
        subjects: ["iPhone 5s", "Galaxy S4"],
        properties: {"iPhone 5s" => ["weight"], "Galaxy S4" => ["weight"]},
        answers: {"iPhone 5s" => {"weight" => "112 grams"}, "Galaxy S4" => {"weight" => "130 grams"}}
      }
      proc.call(response)

      response[:formatted].should == "iPhone 5s => 112 grams; Galaxy S4 => 130 grams"
    end
  end

  describe "with multiple subjects and multiple properties" do
    it "updates the response correctly" do
      proc = Akiva::Brain.formatters[:list_all_answers]
      response = {
        subjects: ["iPhone 5s", "Galaxy S4"],
        properties: {"iPhone 5s" => ["weight", "height"], "Galaxy S4" => ["weight", "height"]},
        answers: {"iPhone 5s" => {"weight" => "112 grams", "height" => "123.8 mm"}, "Galaxy S4" => {"weight" => "130 grams", "height" => "136.6 mm"}}
      }
      proc.call(response)

      response[:formatted].should == "iPhone 5s => Weight: 112 grams, Height: 123.8 mm; Galaxy S4 => Weight: 130 grams, Height: 136.6 mm"
    end
  end

end
