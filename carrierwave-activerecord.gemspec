# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'carrierwave-activerecord'

Gem::Specification.new do |gem|
  gem.authors       = ['Richard Michael']
  gem.email         = ['rmichael@edgeofthenet.org']
  gem.description   = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.summary       = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.homepage      = 'http://github.com/richardkmichael/carrierwave-activerecord'

  # TODO: Explicitly list files, don't use `ls-files`.
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'carrierwave-activerecord'
  gem.require_paths = ['lib']
  gem.version       = CarrierWave::Storage::ActiveRecord::VERSION

  # TODO: Add dependency versions.  Dev happens with 0.6.2.
  gem.add_dependency 'carrierwave'

  # CarrierWave does not depend on ActiveRecord, so add it.
  gem.add_dependency 'activerecord'

  # TODO: Do we need a platform?
  # gem.platform = Gem::Platform::Ruby
end
