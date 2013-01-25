# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

require 'carrierwave-activerecord/storage/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Richard Michael', 'Julien Gantner']
  gem.email         = ['rmichael@edgeofthenet.org', 'julien.gantner@softwareinmotion.de']
  gem.description   = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.summary       = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.homepage      = %q{http://github.com/richardkmichael/carrierwave-activerecord}
  gem.version       = CarrierWave::Storage::ActiveRecord::VERSION

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'carrierwave-activerecord'
  gem.require_paths = ['lib']

  gem.add_dependency 'carrierwave', '~> 0.8.0'
  gem.add_dependency 'activerecord', '~> 3.2.2'

  gem.add_development_dependency 'cucumber', '~> 1.2.1'
  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'sqlite3', '~> 1.3.6'
  gem.add_development_dependency 'guard-cucumber', '~> 1.2.0'
  gem.add_development_dependency 'guard-rspec', '~> 1.2.1'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9.1'

  gem.platform = Gem::Platform::RUBY

  gem.required_ruby_version = '>= 1.9.3'
end
