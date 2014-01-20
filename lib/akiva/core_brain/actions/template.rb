# Akiva::Brain.update do
#
#   add_action :name_of_action do |response|
#     # 'response' is the same hash passed to all before_actions and to the action itself
#     # The following keys are set from the start:
#     response[:filter_matched] => {regex: /[original regex capturing the following (?<stuff_captured>.+)/, action: :name_of_action, [other options]}
#     response[:filter_captures] => Hash of the captures made in the regex e.g. {"stuff_captured" => "words captured from the question"}
#   end
#   
#   # If you're going to work with a huge action, you may want to pass a class instance instead of a block,
#   # the method #process will be called with the current response as an argument.
#   # The important difference is that you must return the new response when exiting #process, instead of modifying "response" as you do in blocks
#   
#    class MyCustomAction
#      def process(response)
#        # do stuff
#        return new_response
#      end
#    end
#
#    add_action :name_of_action, MyCustomAction.new
#
# end