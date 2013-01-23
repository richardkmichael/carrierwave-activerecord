$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'rubygems'
require 'bundler/setup'

require 'carrierwave-activerecord'

require 'sqlite3'
require File.expand_path('../../../spec/database_setup', __FILE__)
