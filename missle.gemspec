# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'missle/version'

Gem::Specification.new do |spec|
  spec.name          = "missle"
  spec.version       = Missle::VERSION
  spec.authors       = ["Josh Deeden"]
  spec.email         = ["jdeeden@gmail.com"]

  spec.summary       = %q{Command abstraction}
  spec.description   = %q{Command abstraction}
  spec.homepage      = "http://github.com/gangster/missle"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "wisper-rspec"
  spec.add_dependency 'wisper'
  spec.add_dependency 'uber'
  spec.add_dependency 'reform'
  spec.add_dependency 'wepo'
  spec.add_dependency 'activemodel'
end
