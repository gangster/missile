# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'missile/version'

Gem::Specification.new do |spec|
  spec.name          = 'missile'
  spec.version       = Missile::VERSION
  spec.authors       = ['Josh Deeden']
  spec.email         = ['jdeeden@gmail.com']

  spec.summary       = 'Command abstraction'
  spec.description   = 'Command abstraction'
  spec.homepage      = 'http://github.com/gangster/missile'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0', '>= 3.3.0'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'wisper-rspec', '~> 0.0.2'
  spec.add_development_dependency 'rubocop', '~> 0.45.0'
  spec.add_dependency 'wisper', '~> 2.0.0.rc1'
  spec.add_dependency 'uber'
  spec.add_dependency 'reform', '~> 2.2'
  spec.add_dependency 'reform-rails', '~> 0.2.0.rc1'

  spec.add_dependency 'dry-validation'
  spec.add_dependency 'activemodel', '~> 4.2.9'
  spec.add_dependency 'wepo'
end
