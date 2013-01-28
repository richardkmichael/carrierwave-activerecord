require 'rubygems'
require 'bundler/setup'
require 'carrierwave-activerecord'
require 'sqlite3'
require 'database_setup'

def create_a_file_in_the_database properties
  active_record_file_class = CarrierWave::Storage::ActiveRecord::ActiveRecordFile
  active_record_file_class.create! properties.merge!({ identifier: identifier })
end
