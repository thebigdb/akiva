# encoding: utf-8
require "spec_helper"

describe "Akiva CoreBrain Filters" do
  it "matches « What's the weight of an iPhone 5s »" do
    question = Akiva::Question.new("What's the weight of an iPhone 5s").run_filters
    question.filter_matched.should be_instance_of(Hash)
    question.filter_matched.should include(action: :get_answers_from_subjects_and_properties)
    question.filter_captures["subjects"].should == "iPhone 5s"
    question.filter_captures["properties"].should == "weight"
  end

  it "matches « What are the weight and height of an iPhone 5s »" do
    question = Akiva::Question.new("What are the weight and height of an iPhone 5s").run_filters
    question.filter_matched.should be_instance_of(Hash)
    question.filter_matched.should include(action: :get_answers_from_subjects_and_properties)
    question.filter_captures["subjects"].should == "iPhone 5s"
    question.filter_captures["properties"].should == "weight and height"
  end

  it "matches « What are the weight, height and width of an iPhone 5s »" do
    question = Akiva::Question.new("What are the weight, height and width of an iPhone 5s").run_filters
    question.filter_matched.should be_instance_of(Hash)
    question.filter_matched.should include(action: :get_answers_from_subjects_and_properties)
    question.filter_captures["subjects"].should == "iPhone 5s"
    question.filter_captures["properties"].should == "weight, height and width"
  end

  it "matches « What are the weight, height and width of the iPhone 5s and the Galaxy S4 »" do
    question = Akiva::Question.new("What are the weight, height and width of the iPhone 5s and the Galaxy S4").run_filters
    question.filter_matched.should be_instance_of(Hash)
    question.filter_matched.should include(action: :get_answers_from_subjects_and_properties)
    question.filter_captures["subjects"].should == "iPhone 5s and the Galaxy S4"
    question.filter_captures["properties"].should == "weight, height and width"
  end

  it "matches « Is the iPhone 5s heavier than the Galaxy S4 »" do
    question = Akiva::Question.new("Is the iPhone 5s heavier than the Galaxy S4").run_filters
    question.filter_matched.should be_instance_of(Hash)
    question.filter_matched.should include(action: :get_answers_from_subjects_and_properties)
    question.filter_captures["subject1"].should == "the iPhone 5s"
    question.filter_captures["subject2"].should == "the Galaxy S4"
    question.filter_captures["comparison_adjective"].should == "heavier"
  end
end