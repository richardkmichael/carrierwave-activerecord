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

  gem.add_dependency 'carrierwave'
  gem.add_dependency 'activerecord'

  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent'

  # TODO: Guard suggests installing notifiers for each platform, they
  # will be activated as required by Guard's listen gem.  But, how do we
  # do `:require => false` in the gemspec?
  
  # group :development do
  #   gem 'rb-inotify', :require => false
  #   gem 'rb-fsevent', :require => false
  #   gem 'rb-fchange', :require => false
  # end

  gem.platform = Gem::Platform::RUBY

  gem.required_ruby_version = '>= 1.9.3'
end
