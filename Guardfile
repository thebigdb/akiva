guard :rspec do
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch("lib/akiva/question.rb") { "spec" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/akiva\.rb$}) { "spec" }
  watch(%r{^lib/akiva/(.+)\.rb$}) do |m|
    "spec/lib/akiva/#{m[1]}_spec.rb"
  end
end
