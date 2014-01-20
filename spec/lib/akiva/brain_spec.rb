require "spec_helper"

describe "Akiva Brain" do
  before { reload_core_brain }
  after { reload_core_brain }

  describe "adding filters" do
    it "is correctly reflected in the filters list" do
      Akiva::Brain.update do
        add_filter :action_name, /first filter/
      end

      Akiva::Brain::filters.first.should == {
        regex: /first filter/,
        action: :action_name
      }

      Akiva::Brain.update do
        add_filter :action_name, /second filter/, other_options: [:a, :b, :c]
      end

      Akiva::Brain::filters.first.should == {
        regex: /second filter/,
        action: :action_name,
        other_options: [:a, :b, :c]
      }
    end
  end


  describe "adding action" do
    it "as a block is correctly reflected in the actions list" do
      action = ->(response){ }

      Akiva::Brain.update do
        add_action :foobar, &action
      end

      Akiva::Brain::actions[:foobar].should == action
    end

    it "as an instance is correctly reflected in the actions list" do
      class MyCustomAction
        def process(response)
          response.merge(processed: true)
        end
      end

      action = MyCustomAction.new

      Akiva::Brain.update do
        add_action :foobar, action
      end

      Akiva::Brain::actions[:foobar].should == action
    end
  end

  describe "adding formatters" do
    it "as a block is correctly reflected in the formatters list" do
      formatter = ->(response){ }

      Akiva::Brain.update do
        add_formatter :foobar, &formatter
      end

      Akiva::Brain::formatters[:foobar].should == formatter
    end

    it "as an instance is correctly reflected in the formatters list" do
      class MyCustomFormatter
        def process(response)
          response.merge(processed: true)
        end
      end

      formatter = MyCustomFormatter.new

      Akiva::Brain.update do
        add_formatter :foobar, formatter
      end

      Akiva::Brain::formatters[:foobar].should == formatter
    end

  end


end