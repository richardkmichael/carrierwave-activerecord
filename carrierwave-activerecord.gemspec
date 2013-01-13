# -*- encoding: utf-8 -*-
#
$:.push File.expand_path('../lib', __FILE__)

require 'carrierwave-activerecord/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Richard Michael']
  gem.email         = ['rmichael@edgeofthenet.org']
  gem.description   = %q{Store CarrierWave uploaded file data in ActiveRecord.}
  gem.summary       = %q{Store CarrierWave uploaded file data in ActiveRecord.}
  gem.homepage      = 'http://github.com/richardkmichael/carrierwave-activerecord'

  # TODO: Explicitly list files, don't use `ls-files`.
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'carrierwave-activerecord'
  gem.require_paths = ['lib']
  gem.version       = CarrierWave::ActiveRecord::VERSION

  # TODO: Add dependency versions.
  gem.add_runtime_dependency 'carrierwave' # FIXME: Should we declare CW as a dep at all?
  gem.add_runtime_dependency 'activerecord'

  gem.add_development_dependency 'sqlite3'
end
