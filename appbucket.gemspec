# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appbucket/version'

Gem::Specification.new do |spec|
  spec.name          = "appbucket-client"
  spec.version       = Appbucket::VERSION
  spec.authors       = ["Andreas Günther"]
  spec.email         = ["andreas.guenther@runtastic.com"]

  spec.summary       = %q{Ruby client for appbucket}
  spec.description   = %q{Provides a ruby interface for working with appbucket.}
  spec.homepage      = "https://github.com/mathiasAichinger/appbucket-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "colorize", "~> 0.8.1"
  spec.add_dependency "rest-client", "~> 1.6.9"
end
