# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/omniauth-onetime/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-onetime'
  spec.version       = OmniAuth::Onetime::VERSION
  spec.authors       = ['thoughtafter']
  spec.email         = ['thoughtafter@gmail.com']

  spec.summary       = 'An omniauth strategy using secure onetime passwords.'
  spec.homepage      = 'https://github.com/thoughtafter/omniauth-onetime'
  spec.license       = 'LGPL-3.0'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_development_dependency 'bundler', '>= 2.2'
  spec.add_development_dependency 'minitest', '>= 5.0'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'rubocop', '>= 1.20'
  spec.add_development_dependency 'rubocop-performance', '>= 1.14'
  spec.add_development_dependency 'simplecov-cobertura', '>= 2.1'

  spec.add_runtime_dependency 'bcrypt', '>= 3.1'
  spec.add_runtime_dependency 'omniauth', '>= 2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
