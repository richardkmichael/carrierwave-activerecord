# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)

require 'carrierwave-activerecord/storage/version'

Gem::Specification.new do |gem|
  gem.name          = 'carrierwave-activerecord'
  gem.authors       = ['Richard Michael', 'Julien Gantner']
  gem.email         = ['rmichael@edgeofthenet.org', 'julien.gantner@softwareinmotion.de']
  gem.homepage      = %q{http://github.com/richardkmichael/carrierwave-activerecord}
  gem.version       = CarrierWave::Storage::ActiveRecord::VERSION
  gem.require_paths = ['lib']

  gem.description   = %q{Store CarrierWave uploaded files using ActiveRecord.}
  gem.summary       = %q{Store CarrierWave uploaded files using ActiveRecord.}


  files_to_include = %w{
    LICENSE
    README.md

    Rakefile

    carrierwave-activerecord.gemspec

    lib/carrierwave-activerecord.rb
    lib/carrierwave-activerecord/storage/active_record_file.rb
    lib/carrierwave-activerecord/storage/file.rb
    lib/carrierwave-activerecord/storage/storage_provider.rb
    lib/carrierwave-activerecord/storage/version.rb

    spec/spec_helper.rb
    spec/database_setup.rb
    spec/lib/carrierwave-activerecord/storage/file_spec.rb
    spec/lib/carrierwave-activerecord/storage/storage_provider_spec.rb
    spec/lib/carrierwave-activerecord/carrierwave-activerecord_spec.rb
  }

  gem.files         = files_to_include
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  # CarrierWave has broken in 0.x releases.
  gem.add_runtime_dependency 'carrierwave', '~> 1.0.0'

  # ActiveRecord 3.3 is unlikely, but prevent it just in case.
  gem.add_runtime_dependency 'activerecord', '~> 5.0'

  gem.add_development_dependency 'sqlite3', '~> 1.3.0'
  gem.add_development_dependency 'rspec', '~> 2.12.0'

  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'
end
