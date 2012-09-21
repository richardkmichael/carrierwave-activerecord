# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'carrierwave-activerecord'

Gem::Specification.new do |gem|
  gem.authors       = ['Richard Michael', 'Julien Gantner']
  gem.email         = ['rmichael@edgeofthenet.org', 'julien.gantner@softwareinmotion.de']
  gem.description   = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.summary       = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.homepage      = 'http://github.com/richardkmichael/carrierwave-activerecord'

  # TODO: Explicitly list files, don't use `ls-files`.
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'carrierwave-activerecord'
  gem.require_paths = ['lib']
  gem.version       = CarrierWave::Storage::ActiveRecord::VERSION

  # usage dependencies
  gem.add_dependency "carrierwave", "~> 0.6.2"
  gem.add_dependency "activerecord", "~> 3.2.0"

  # required development dependencies
  gem.add_development_dependency "cucumber", "~> 1.2.1"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "sqlite3", "~> 1.3.6"

  # add default plattform as suggested in
  # http://http://docs.rubygems.org/read/chapter/20#platform
  gem.platform = Gem::Platform::RUBY

  # add ruby version requirement
  gem.required_ruby_version = '>= 1.9.3'
end
