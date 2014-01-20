# Akiva::Brain.update do
#
#   add_formatter :formatter_name do |response|
#     # you must set response[:formatted] as a textual answer to the question
#   end
#
#   # If you're going to work with a huge formatter, you may want to pass a class instance instead of a block,
#   # the method #process will be called with the current response as an argument.
#   # The important difference is that you must return the new response when exiting #process, instead of modifying "response" as you do in blocks
#   
#    class MyCustomFormatter
#      def process(response)
#        # do stuff
#        return new_response
#      end
#    end
#
#    add_formatter :name_of_action, MyCustomFormatter.new
# end