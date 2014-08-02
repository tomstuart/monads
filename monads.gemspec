lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monads/version'

Gem::Specification.new do |spec|
  spec.name          = 'monads'
  spec.version       = Monads::VERSION
  spec.author        = 'Tom Stuart'
  spec.email         = 'tom@codon.com'
  spec.summary       = 'Simple Ruby implementations of some common monads.'
  spec.homepage      = 'https://github.com/tomstuart/monads'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'
end
