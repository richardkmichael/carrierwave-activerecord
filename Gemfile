source :rubygems

# TODO: Fix with bundler's config.local to override.
# Override CarrierWave from the gemspec with a local CarrierWave checkout.
gem 'carrierwave', :path => '/Users/rmichael/Documents/Personal/Source/carrierwave'
# gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git', :branch => '0.8.0'

gemspec # See: carrierwave-activerecord.gemspec

# Helpful development gems which are not development "dependencies".
group :development do
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'rb-fchange', :require => false
end
