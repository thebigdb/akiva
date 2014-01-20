require "spec_helper"

describe "Akiva CoreBrain Helper: Units" do
  describe "compare" do
    context "with incomparable units" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters", "7 grams"])
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::IncompatibleUnitsError)
      end
    end

    context "with unknown units" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters", "7 zigzagzoug"])
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::UnitNotRecognizedError)
      end
    end

    context "with no values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(nil)
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::NeedTwoValuesToCompareError)

        u = Akiva::Brain::Helpers::Units.new([])
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::NeedTwoValuesToCompareError)
      end
    end

    context "with in an incorrect type of values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new("my values !")
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::InputMustBeAnArray)
      end
    end

    context "with not enough values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters"])
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::NeedTwoValuesToCompareError)
      end
    end

    context "with too many values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters", "9 cm", "45 dm"])
        expect { u.compare }.to raise_error(Akiva::Brain::Helpers::Units::CantCompareMoreThanTwoValuesError)
      end
    end

    context "with different values" do
      it "gives the correct answer" do
        u = Akiva::Brain::Helpers::Units.new(["120 cm", "100 meters"])
        u.compare
        u.result.should == "inferior"
      end
    end

    context "with the same values" do
      it "gives the correct answer" do
        u = Akiva::Brain::Helpers::Units.new(["120 cm", "1.2 m"])
        u.compare
        u.result.should == "equal"
      end
    end

    context "with multiplicators" do
      it "gives the correct answer" do
        u = Akiva::Brain::Helpers::Units.new(["120 cm", "1.2 m"])
        u.compare(multiplicators: [nil, 2])
        u.result.should == "inferior"
      end
    end
  end


  it "can adjust units" do
    result = Akiva::Brain::Helpers::Units.adjust_units(Unit("25000000 g"), Unit("5000 kg"))
    result.should == [Unit("25000 kg"), Unit("5000 kg")]
  end


  describe "sort" do
    context "with incomparable units" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters", "7 grams"])
        expect { u.sort }.to raise_error(Akiva::Brain::Helpers::Units::IncompatibleUnitsError)
      end
    end

    context "with unknown units" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(["100 meters", "7 zigzagzoug"])
        expect { u.sort }.to raise_error(Akiva::Brain::Helpers::Units::UnitNotRecognizedError)
      end
    end

    context "with no values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(nil)
        expect { u.sort }.to raise_error(Akiva::Brain::Helpers::Units::NeedTwoValuesToCompareError)
      end
    end

    context "with too many values" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new(101.times.map{ Unit("#{rand(150)} cm") })
        expect { u.sort }.to raise_error(Akiva::Brain::Helpers::Units::CantCompareMoreThanTwoValuesError)
      end
    end

    context "with different values" do
      it "gives the correct answer" do
        u = Akiva::Brain::Helpers::Units.new(["120 cm", "100 meters", "7 m", "12.3 m"])
        u.sort
        u.result.should == ["120 cm", "7 m", "12.3 m", "100 m"]
      end
    end
  end




  describe "convert" do
    context "with unknown units" do
      it "raises the correct exception" do
        u = Akiva::Brain::Helpers::Units.new("100 meters")
        expect { u.convert("cmZZZ") }.to raise_error(Akiva::Brain::Helpers::Units::UnitNotRecognizedError)
      end
    end

    context "with acceptable params" do
      it "gives the correct answer" do
        u = Akiva::Brain::Helpers::Units.new("100 ly")
        u.convert("cm")
        u.result.should == "9.460528412464108e+19"
      end
    end

  end

end