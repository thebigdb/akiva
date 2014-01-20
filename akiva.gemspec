$:.push File.expand_path("../lib", __FILE__)
require "akiva/version"

Gem::Specification.new do |s|
  s.name = "akiva"
  s.version = Akiva::VERSION::STRING
  s.summary = "Simple natural language processing, question-answering artificial intelligence, based on TheBigDB"
  s.description = "Akiva is a simple natural language processing, question-answering artificial intelligence. It is a demonstration of how to use the API of TheBigDB (http://thebigbdb.com) to create knowledgable software."
  s.authors = ["Christophe Maximin"]
  s.email = "christophe@thebigdb.com"
  s.homepage = "https://github.com/thebigdb/akiva"
  s.licenses = ['MIT']

  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency "rack", "~> 1.4"
  s.add_runtime_dependency "ruby-units", "~> 1.4"
  s.add_runtime_dependency "thebigdb", "~> 1.3"
  s.add_runtime_dependency "thor", "~> 0.18"
  # s.add_runtime_dependency "numbers_in_words", "~> 0.0", ">= 0.0.1"
  s.add_runtime_dependency "awesome_print", "~> 1.2"

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 2.12"
  s.add_development_dependency "guard-rspec", "~> 2.3"
  s.add_development_dependency "rb-inotify", "~> 0"
  s.add_development_dependency "rb-fsevent", "~> 0"
  s.add_development_dependency "rb-fchange", "~> 0"
  s.add_development_dependency "webmock", "~> 1.9"



  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  
  s.require_paths = ["lib"]
end
