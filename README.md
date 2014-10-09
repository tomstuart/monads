# Monads

This library is some specs that i stole from [tomstuart](https://github.com/tomstuart/monads) that are about [monads](http://en.wikipedia.org/wiki/Monad_(functional_programming)).

[I read this thing by tomstuart](http://codon.com/refactoring-ruby-with-monads) that i thought was cool and so I wanted to tdd some monads so i was going to write some monad tests but then i realized that that would be hard and that tomstuart had, in fact, actually already written some monad tests!

This thingy reflects how far I have progressed in understanding these monads: [![Build Status](https://travis-ci.org/coleww/TDD_SOME_monads.svg?branch=cole)](https://travis-ci.org/coleww/TDD_SOME_monads)

In order to TDD some monads, I bet you have to run something like:

```console
$ bundle install
$ rspec
```

And then do that red-green-refactor business and maybe cheat by looking at the original repo.

But I wouldn't actually know because I am doing this all via the github website and have not actually even cloned this thing yet. The internet is, pretty cool. It lets me be, really lazy. In good ways.



#### The following is some stuff from the original repo that will probably be helpful:


The most important method of each implementation is `#and_then` (a.k.a. `bind` or `>>=`), which is used to connect together a sequence of operations involving the value(s) inside the monad. Each monad also has a `.from_value` class method (a.k.a. `return` or `unit`) for constructing an instance of that monad from an arbitrary value.

## `Optional`

(a.k.a. the [maybe monad](http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#The_Maybe_monad))

An `Optional` object contains a value that might be `nil`.

```irb
>> require 'monads/optional'
=> true

>> include Monads
=> Object

>> optional_string = Optional.new('hello world')
=> #<struct Monads::Optional value="hello world">

>> optional_result = optional_string.and_then { |string| Optional.new(string.upcase) }
=> #<struct Monads::Optional value="HELLO WORLD">

>> optional_result.value
=> "HELLO WORLD"

>> optional_string = Optional.new(nil)
=> #<struct Monads::Optional value=nil>

>> optional_result = optional_string.and_then { |string| Optional.new(string.upcase) }
=> #<struct Monads::Optional value=nil>

>> optional_result.value
=> nil
```

## `Many`

(a.k.a. the [list monad](http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#Collections))

A `Many` object contains multiple values.

```irb
>> require 'monads/many'
=> true

>> include Monads
=> Object

>> many_strings = Many.new(['hello world', 'goodbye world'])
=> #<struct Monads::Many values=["hello world", "goodbye world"]>

>> many_results = many_strings.and_then { |string| Many.new(string.split(/ /)) }
=> #<struct Monads::Many values=["hello", "world", "goodbye", "world"]>

>> many_results.values
=> ["hello", "world", "goodbye", "world"]
```

## `Eventually`

(a.k.a. the [continuation monad](http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#Continuation_monad))

An `Eventually` object contains a value that will eventually be available, perhaps as the result of an asynchronous process (e.g. a network request).

```irb
>> require 'monads/eventually'
=> true

>> include Monads
=> Object

>> eventually_string = Eventually.new do |success|
     Thread.new do
       sleep 5
       success.call('hello world')
     end
   end
=> #<struct Monads::Eventually block=#<Proc>>

>> eventually_result = eventually_string.and_then do |string|
     Eventually.new do |success|
       Thread.new do
         sleep 5
         success.call(string.upcase)
       end
     end
   end
=> #<struct Monads::Eventually block=#<Proc>>

>> eventually_result.run { |string| puts string }
=> #<Thread run>
HELLO WORLD
```
