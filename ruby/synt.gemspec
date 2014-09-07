# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synt/version'

Gem::Specification.new do |spec|
  spec.name          = "synt"
  spec.version       = Synt::VERSION
  spec.authors       = ["Brent Lintner"]
  spec.email         = ["brent.lintner@gmail.com"]
  spec.summary       = "Similar code analysis."
  spec.description   = "Calculate the percentage of difference between code."
  spec.homepage      = "https://github.com/brentlintner/synt"
  spec.license       = "ISC"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = ["synt"]
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9'
  spec.add_runtime_dependency 'manowar', '0.0.1'
  spec.add_runtime_dependency 'slop', '3.6.0'
  spec.add_development_dependency "bundler", "~> 1.7"
end
