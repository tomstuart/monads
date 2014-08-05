# Monads

[![Build Status](https://travis-ci.org/tomstuart/monads.svg?branch=master)](https://travis-ci.org/tomstuart/monads)

This library provides simple Ruby implementations of some common [monads](http://en.wikipedia.org/wiki/Monad_(functional_programming)).

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
