require "thor"

module Akiva
  class CLI < Thor

    desc "ask QUESTION", "Process a question, and display the answer"
    # method_option "verbose", type: :boolean, aliases: "-v", desc: "Displays the elements found in the question"
    # option :verbose, type: :boolean, aliases: "-v"
    option "verbose", type: :boolean, aliases: "-v", desc: "Displays the requests made to TheBigDB"
    option "headers", type: :boolean, desc: "Displays headers of the requests made to TheBigDB (depends on --verbose/-v)", default: false
    option "caller", type: :boolean, desc: "Displays stack trace from which each request made to TheBigDB is made (depends on --verbose/-v)", default: false
    option "api-host", type: :string, desc: "Host to send requests for TheBigDB", default: "api.thebigdb.com"

    def ask(question)
      TheBigDB.raise_on_api_status_error = true

      TheBigDB.api_host = options["api-host"]

      if options["verbose"]
        require "awesome_print"
        TheBigDB.before_request_execution = lambda do |request|
          puts "REQUEST DATA SENT:"
          data_sent = request.data_sent
          data_sent.delete("headers") unless options["headers"]
          ap data_sent
          if options["caller"]
            puts "CALLED FROM:"
            puts caller.join("\n")
          end
          puts
        end

        TheBigDB.after_request_execution = lambda do |request|
          puts "REQUEST DATA RECEIVED:"
          data_received = request.data_received
          data_received.delete("headers") unless options["headers"]
          ap data_received
          puts
        end
      end

      akiva_question = Akiva::Question.new(question)
      begin
        if response = akiva_question.formatted_response
          puts response.gsub("; ", "\n")
        else
          puts "Sorry, Akiva can't answer that question for now."
        end
      rescue TheBigDB::Request::ApiStatusError
        puts "Sorry, it looks like TheBigDB is currently unavailable."
      end

    end

  end
end

Akiva::CLI.start