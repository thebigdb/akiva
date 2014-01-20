require "spec_helper"

describe "Akiva CoreBrain" do

  describe "answers" do
    it "« What's the weight of an iPhone 5s »" do
      stub_statements(:a0)

      question = Akiva::Question.new("What's the weight of an iPhone 5s").process
      question.response[:formatted].should == "112 grams"
    end

    it "executes on « What are the weight and height of an iPhone 5s »" do
      stub_statements(:a0, :a1, :a2)

      question = Akiva::Question.new("What are the weight and height of an iPhone 5s").process
      question.response[:formatted].should == "Weight: 112 grams, Height: 123.8 mm"
    end

    it "executes on « What are the weight of an iPhone 5s and a Galaxy S4 »" do
      stub_statements(:a0, :a3, :a4)

      question = Akiva::Question.new("What are the weight of an iPhone 5s and a Galaxy S4").process
      question.response[:formatted].should == "iPhone 5s => 112 grams; Galaxy S4 => 130 grams"
    end

    it "executes on « What are the weight and height of an iPhone 5s and a Galaxy S4 »" do
      stub_statements(:a0, :a1, :a2, :a3, :a4, :a5, :a6)

      question = Akiva::Question.new("What are the weight and height of an iPhone 5s and a Galaxy S4").process
      question.response[:formatted].should == "iPhone 5s => Weight: 112 grams, Height: 123.8 mm; Galaxy S4 => Weight: 130 grams, Height: 136.6 mm"
    end

    it "executes on « What is the salary of the Director of Public Affairs and Communication »" do
      stub_statements(:b0)

      question = Akiva::Question.new("What is the salary of the Director of Public Affairs and Communication").process
      question.response[:formatted].should == "$10,000"
    end

    it "executes on « What is the salary and benefits of the Director of Public Affairs and Communication »" do
      stub_statements(:b0, :b1, :b2)

      question = Akiva::Question.new("What is the salary and benefits of the Director of Public Affairs and Communication").process
      question.response[:formatted].should == "Salary: $10,000, Benefits: Dental"
    end

    it "executes on « Is the iPhone 5s heavier than the Galaxy S4 »" do
      stub_statements(:a0, :a3, :a4)

      question = Akiva::Question.new("Is the iPhone 5s heavier than the Galaxy S4").process
      question.response[:formatted].should == "No (iPhone 5s => 112 grams; Galaxy S4 => 130 grams)"
    end

  end

  describe "doesn't yet answer", hidden: false do

    # Please remember that for each question listed here,
    # you should create tests in an existing file (or create a new one for a new action) in filters/, same for actions/ and formatters/ if necessary
    # Also note:
    # - they are not in order of importance, just pick one you like!
    # - if the data for answering the question is not in TheBigDB (very likely), just add it! Or if you don't have enough data to add it yourself, ask for help on the forum, someone will surely land a hand to make it happen!
    # - the list is obviously non exhaustive, please add questions you wish Akiva to answer

    it "answers « How long does a tiger live »"
    it "answers « How long is the george washington bridge »"
    it "answers « How long is the movie ted »"
    it "answers « How long is the year on Pluto »"
    it "answers « How many divorces did Larry King have »"
    it "answers « How many ethnic groups exist in Nigeria »"
    it "answers « How many feet are there in a kilometer »"
    it "answers « How many languages are spoken in Afghanistan »"
    it "answers « How many people live in Israel »"
    it "answers « How many people live on Earth »"
    it "answers « How much does it cost to study at MIT »"
    it "answers « How old is Elon Musk »"

    it "answers « In what year did Isaac Bashevis Singer receive a Nobel Prize »"
    it "answers « In what year did Mozart die »"

    it "answers « Of all European countries, which has the smallest area »"
    it "answers « Show the capital of the 2nd largest country in Asia »"
    it "answers « What countries speak Portuguese »"
    it "answers « What country in the world has the longest coastline »"
    it "answers « What invention is Marconi responsible for »"
    it "answers « What is Jupiter's atmosphere made of »"
    it "answers « What is the atmosphere of Jupiter like »"
    it "answers « What is the capital of Greenland »"
    it "answers « What is the height requirement for space mountain »"
    it "answers « What is the longest river in the world »"
    it "answers « What is the terrain like in Mexico »"
    it "answers « What music did Debussy compose »"
    it "answers « What planet has the smallest surface area »"
    it "answers « What South-American country has the largest population »"
    it "answers « What's the definition of dynamic programming »"
    it "answers « What's the largest city in Florida »"

    it "answers « When did Abraham Lincoln die »"
    it "answers « When was Beethoven born »"
    it "answers « When was George Washington born »"
    it "answers « When was the constitution adopted in the most populous country in Africa »"

    it "answers « Where did Natalie Portman go to college »"
    it "answers « Where do people speak Urdu »"
    it "answers « Where was Yehudi Menuhin born »"

    it "answers « Which is deeper, the Baltic Sea or the North Sea »"

    it "answers « Who composed the opera Semiramide »"
    it "answers « Who created the first typewriter »"
    it "answers « Who directed The Birds »"
    it "answers « Who first discovered radiocarbon dating »"
    it "answers « Who founded Napster »"
    it "answers « Who invented the first telephone »"
    it "answers « Who invented the telegraph »"
    it "answers « Who is the producer of the Titanic »"
    it "answers « Who produced Ferris bueller's day off »"
    it "answers « Who was governor of California during Bill Clinton presidency »"
    it "answers « Who was president in 1881 »"
    it "answers « Who was the fifth president of the United States »"
    it "answers « Who was vice president under Thomas Jefferson »"
    it "answers « Who won the Nobel prize for literature in 1987 »"
    it "answers « Who wrote the Gift of the Magi »"
    it "answers « Who wrote the Grand Design »"
    it "answers « Who wrote the music to Star Wars »"
  end

  describe "with a mix a instances and blocks as actions and formatters" do
    it "correctly executes each one of them" do
      class MyCustomAction
        def process(response)
          new_response = response.merge(ran_through_custom_action: true)
          new_response
        end
      end

      class MyCustomFormatter
        def process(response)
          new_response = response.merge(ran_through_custom_formatter: true)
          new_response
        end
      end

      Akiva::Brain.update do
        add_filter :foobar, /\Aexecute foobar\Z/, before_action: [:pre_action_one, :pre_action_two], formatter: :custom_formatter

        add_action :foobar do |response|
          response[:ran_through_main_action] = true
        end

        add_action :pre_action_one do |response|
          response[:ran_through_action_one] = true
        end

        add_action :pre_action_two, MyCustomAction.new

        add_formatter :custom_formatter, MyCustomFormatter.new
      end

      question = Akiva::Question.new("execute foobar").run_filters.execute_action.execute_formatter
      question.response.should include(ran_through_main_action: true)
      question.response.should include(ran_through_action_one: true)
      question.response.should include(ran_through_custom_action: true)
      question.response.should include(ran_through_custom_formatter: true)

    end
  end

end