# Akiva::Brain.update do
#
#   add_filter :name_of_the_action_that_will_be_called,
#     /regex matching that will trigger this action/i,
#     before_action: [:pre_action_one, :pre_action_two, [...]], # will be executed in this order
#     after_action: [:post_action_one, :post_action_two, [...]], # will be executed in this order
#     formatter: :name_of_formatter
#
# end