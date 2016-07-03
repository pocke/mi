# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mi/version'

Gem::Specification.new do |spec|
  spec.name          = "mi"
  spec.version       = Mi::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = %q{Better `rails g migration`}
  spec.description   = %q{Mi is a generator of migration file instead of `rails generate migration`.}
  spec.homepage      = "https://github.com/pocke/mi"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.licenses = ['CC0-1.0']
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'rails', '>= 4.0.0'
  spec.add_runtime_dependency 'activerecord', '>= 4.0.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rubocop', '~> 0.41.1'

  # testing
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.5'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
  spec.add_development_dependency 'rspec-power_assert', '~> 0.3.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.13'
  spec.add_development_dependency 'simplecov', '~> 0.11.0'
end
