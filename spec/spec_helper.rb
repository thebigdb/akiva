require "rspec"
require "webmock/rspec"
require "awesome_print"
require "akiva"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.order = "random"

  config.include AkivaBrainHelpers
  config.include AkivaStatementsHelpers
  
  config.before(:each) do
    TheBigDB.reset_default_configuration

    TheBigDB.api_host = "fake.test.host"
    # uncomment the following line to show what params are "sent" (obviously nothing is really sent, it's all catched by webmock)
    # TheBigDB.before_request_execution = ->(request){ ap request.data_sent["params"] }
  end

  config.after(:each) do
    TheBigDB.reset_default_configuration
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding hidden: true

  config.expect_with :rspec do |c|
    # c.syntax = :expect
    # c.syntax = :should
    c.syntax = [:should, :expect]  # default, enables both `should` and `expect`
  end
end