require 'bundler'

# OR, :testing?  Could be a problem because we're actually using a .gemspec,
# and rubygems does not have a notion of test-only dependencies.
Bundler.require :default, :development

Combustion.path = 'spec/dummy'
Combustion.initialize!(%w|active_record
                          carrierwave/orm/activerecord
                          action_controller
                          action_view
                          action_mailer
                          sprockets|)

# How to use capybara with minitest?
# require 'capybara/rspec'
require 'capybara/rails'


# --> config.ru
# require 'rubygems'
# require 'bundler'

# Bundler.require :default, :development

# Combustion.initialize!
# run Combustion::Application

# Need a controller to serve the files, a route.
# Need views: new, create, show, index
