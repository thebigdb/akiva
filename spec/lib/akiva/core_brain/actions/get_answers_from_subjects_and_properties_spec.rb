require "spec_helper"

# TODO rebuild specs like the preparators

describe "Akiva CoreBrain Actions" do
  it "executes on « What's the weight of an iPhone 5s »" do
    stub_statements(:a0)

    question = Akiva::Question.new("What's the weight of an iPhone 5s").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["iPhone 5s"])
    question.response.should include(properties: {"iPhone 5s" => ["weight"]})
    question.response.should include(answers: {"iPhone 5s" => {"weight" => "112 grams"}})
  end

  it "executes on « What are the weight and height of an iPhone 5s »" do
    stub_statements(:a0, :a1, :a2)

    question = Akiva::Question.new("What are the weight and height of an iPhone 5s").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["iPhone 5s"])
    question.response.should include(properties: {"iPhone 5s" => ["weight", "height"]})
    question.response.should include(answers: {"iPhone 5s" => {"weight" => "112 grams", "height" => "123.8 mm"}})
  end

  it "executes on « What are the weight of an iPhone 5s and a Galaxy S4 »" do
    stub_statements(:a0, :a3, :a4)

    question = Akiva::Question.new("What are the weight of an iPhone 5s and a Galaxy S4").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["iPhone 5s", "Galaxy S4"])
    question.response.should include(properties: {"iPhone 5s" => ["weight"], "Galaxy S4" => ["weight"]})
    question.response.should include(answers: {"iPhone 5s" => {"weight" => "112 grams"}, "Galaxy S4" => {"weight" => "130 grams"}})
  end

  it "executes on « What are the weight and height of an iPhone 5s and a Galaxy S4 »" do
    stub_statements(:a0, :a1, :a2, :a3, :a4, :a5, :a6)

    question = Akiva::Question.new("What are the weight and height of an iPhone 5s and a Galaxy S4").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["iPhone 5s", "Galaxy S4"])
    question.response.should include(properties: {"iPhone 5s" => ["weight", "height"], "Galaxy S4" => ["weight", "height"]})
    question.response.should include(answers: {"iPhone 5s" => {"weight" => "112 grams", "height" => "123.8 mm"}, "Galaxy S4" => {"weight" => "130 grams", "height" => "136.6 mm"}})
  end

  it "executes on « What is the salary of the Director of Public Affairs and Communication »" do
    stub_statements(:b0)

    question = Akiva::Question.new("What is the salary of the Director of Public Affairs and Communication").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["Director of Public Affairs and Communication"])
    question.response.should include(properties: {"Director of Public Affairs and Communication" => ["salary"]})
    question.response.should include(answers: {"Director of Public Affairs and Communication" => {"salary" => "$10,000"}})
  end

  it "executes on « What is the salary and benefits of the Director of Public Affairs and Communication »" do
    stub_statements(:b0, :b1, :b2)

    question = Akiva::Question.new("What is the salary and benefits of the Director of Public Affairs and Communication").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["Director of Public Affairs and Communication"])
    question.response.should include(properties: {"Director of Public Affairs and Communication" => ["salary", "benefits"]})
    question.response.should include(answers: {"Director of Public Affairs and Communication" => {"salary" => "$10,000", "benefits" => "Dental"}})
  end

  it "executes on « Is the iPhone 5s heavier than the Galaxy S4 »" do
    stub_statements(:a0, :a3, :a4)

    question = Akiva::Question.new("Is the iPhone 5s heavier than the Galaxy S4").run_filters.execute_action
    question.response.should be_instance_of(Hash)
    question.response.should include(subjects: ["iPhone 5s", "Galaxy S4"])
    question.response.should include(properties: {"iPhone 5s" => ["weight"], "Galaxy S4" => ["weight"]})
    question.response.should include(answers: {"iPhone 5s" => {"weight" => "112 grams"}, "Galaxy S4" => {"weight" => "130 grams"}})
    question.response.should include(comparison_boolean_result: false)
  end

end