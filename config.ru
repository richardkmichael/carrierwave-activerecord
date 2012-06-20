require 'rubygems'
require 'bundler'

Bundler.require :default, :development

Combustion.path = 'spec/dummy'
# Combustion.initialize!
Combustion.initialize!('active_record',
                     # 'carrierwave/orm/activerecord',
                       'action_controller',
                       'action_view',
                       'action_mailer',
                       'sprockets')
run Combustion::Application
