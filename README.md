Akiva
=====

[![Build Status](https://secure.travis-ci.org/thebigdb/akiva.png)](http://travis-ci.org/thebigdb/akiva)

Akiva is a simple natural-language-processing, question-answering, artificial intelligence.
  
Its main role is to take a question, deconstruct it in order to query the 
collaborative database of facts [TheBigDB](http://thebigdb.com), and format the answer into something readable for a human.

Akiva is obviously at a very early stage, and your contributions are more than welcome! See the [Contributing](https://github.com/thebigdb/akiva#contributing) section below for more info.

## Why?

> ** What's the point? Isn't Google's Knowledge graph enough? What about Wolfram|Alpha? **  
> -- you, right now

STORY TIME!  
Back in 2005, while bored to death in a college class and daydreaming about how knowledge is structured, I asked myself why there wasn't anywhere I could ask questions in natural language. Because it would be pretty cool if there was.  
I went back home, prototyped a little program doing just that. It sucked but it kinda worked, so I thought *"well, it isn't that hard, I guess geniuses everywhere are working on that, no need for me to spend more time on it. It surely will be available to everyone soon enough!"*. **Three years** passed: nothing.  
The year 2009 saw the release of Wolfram|Alpha, which pretty much blew my mind: it was almost perfect. I guessed I just needed to wait a few more years and I can have all my trivial questions answered.  
Fast forward **five more years**, and I'm sad to see this (as of January 6th, 2014):  

[Google](http://imgur.com/RWjgcoM), [Wolfram|Apha](http://imgur.com/4QOHcN1), [Yahoo!](http://imgur.com/KXYnoqA) and [Bing](http://imgur.com/oOTloSQ) fail to answer the simple question « Is the iPhone 5s heavier than the Galaxy S4? » (click their names to see the results given);  
Akiva answers "**No (iPhone 5s => 112 grams; Galaxy S4 => 130 grams)**". With only a few lines of code.

With the same few lines, Akiva can accurately and smartly answer the following questions:  

* « What are the weight, width and height of an iPhone 5s and a Galaxy S4 ? »   
* « What is the height requirement for Space Mountain ? »  

… and much more.
 
  
**TL;DR: I truly love Google's Knowledge graph; I'm an eternal fan of Wolfram|Alpha, but I'm tired of waiting for search engines to implement a fully working simple question-answering engine.  
Still, Akiva is not trying to be a real "*computational* knowledge engine" so it is NOT competing at all with Wolfram|Alpha.**  
  
## « It's nothing new!!! »

Maybe. What I, and you probably will, like about Akiva, is the fact that is always improving from two different angles:
  
* Akiva is open-source and a free software, so it can answer more and more types of questions with time
* Akiva's data source is the collaborative [TheBigDB](http://thebigdb.com), which makes it more knowledgable everyday

## Usage

    gem install akiva

You can then ask a question like this: 

    $ akiva ask "What's the weight of an iPhone 5s ?"

    # Will output something like:
    #   112 grams

Or you can ask a more complex question, like this one:

    $ akiva ask "What are the weight, width and height of an iPhone 5s, a Nexus 5 and a Galaxy S4 ?"

    # Will output something like:
    #   iPhone 5s => Weight: 112 grams, Width: 58.6 mm, Height: 123.8 mm
    #   Nexus 5 => Weight: 130 grams, Width: 69.17 mm, Height: 137.84 mm
    #   Galaxy S4 => Weight: 130 grams, Width: 58.6 mm, Height: 136.6 mm

In order to integrate it within an existing app, you can do something like this:
    
    require "akiva"
    puts Akiva::Question.new("What are the weight, width and height of an iPhone 5s, a Nexus 5 and a Galaxy S4 ?").formatted_response

Tip: If you're thinking about caching the requests made to TheBigDB, you should probably check out [the section "Caching" on its github page](https://github.com/thebigdb/thebigdb-ruby#caching).

## Expanding

Akiva is quite easily expandable. Take for example this completely useless example, where Akiva would tell you what's the first word out of a list you provided. 

    require "akiva"
    
    Akiva::Brain.update do
      add_filter :get_first_word, /\AWhat's the first word of (?<words>.+?)\??\Z/i, formatter: :display_expected_word
      
      add_action :get_first_word do |response|
        response[:first_word] = response[:filter_captures]["words"].split(/ /).first
      end

      add_formatter :display_expected_word do |response|
        response[:formatted] = "The word you're looking for is: « #{response[:first_word]} »"
      end
    end

    # execution looks like:
    # Akiva::Question.new("What's the first word of love is stronger than hate?").formatted_response
    # => "The word you're looking for is: « love »"

For more info, you'll probably want to take a look at the templates for filters in [lib/akiva/core_brain/filters/template.rb](https://github.com/thebigdb/akiva/blob/master/lib/akiva/core_brain/filters/template.rb), actions in [lib/akiva/core_brain/actions/template.rb](https://github.com/thebigdb/akiva/blob/master/lib/akiva/core_brain/actions/template.rb) and formatters in [lib/akiva/core_brain/formatters/template.rb](https://github.com/thebigdb/akiva/blob/master/lib/akiva/core_brain/formatters/template.rb).  
Also, don't hesitate to look around, see how existing filters/actions/formatters are built.


## Contributing

You can run the tests with:
  
    $ bundle install
    $ bundle exec rspec spec/

As you can see, there are lots of types of questions Akiva can't answer yet (see [spec/lib/akiva/core_brain/question_spec.rb](https://github.com/thebigdb/akiva/blob/master/spec/lib/akiva/core_brain/question_spec.rb)). Just take one of them and make it work!

There are no crazy rules to contribute, just write good code, good tests, and send a pull request. It will really appreciated!

## List of question types currently understood

This is a non-exhaustive list of question types Akiva can answer. Just remember that the fact that Akiva actually has the data to answer the question is entirely dependent on what is available in TheBigDB.
The words in parenthesis are variable.

    What's (the weight) of (an iPhone 5s) ?
      >>> 112 grams
      
    What are (the weight and height) of (an iPhone 5s) ?
      >>> Weight: 112 grams, Height: 123.8 mm
      
    What are (the weight) of (an iPhone 5s and a Galaxy S4) ?
      >>> iPhone 5s => 112 grams; Galaxy S4 => 130 grams
      
    What are (the weight and height) of (an iPhone 5s and a Galaxy S4) ?
      >>> iPhone 5s => Weight: 112 grams, Height: 123.8 mm
          Galaxy S4 => Weight: 130 grams, Height: 136.6 mm
      
    Is (the iPhone 5s) (heavier) than (the Galaxy S4) ?
      >>> No (iPhone 5s => 112 grams; Galaxy S4 => 130 grams)


## License

This software is distributed under the MIT License. Copyright (c) 2014, Christophe Maximin <christophe@thebigdb.com>
