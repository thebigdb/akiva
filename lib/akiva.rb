require "thebigdb"
# require "numbers_in_words/duck_punch"
require "ruby-units"

%w(
  brain
  core_brain/loader
  question
).each do |file_name|
  require File.join(File.dirname(__FILE__), "akiva", file_name)
end