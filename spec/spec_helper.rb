# -*- encoding: utf-8 -*-

require 'rubygems'
require 'bundler/setup'
require 'carrierwave-activerecord'
require 'sqlite3'
require 'database_setup'

# def file_path( *paths )
#   File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', *paths))
# end

# def public_path( *paths )
#   File.expand_path(File.join(File.dirname(__FILE__), 'public', *paths))
# end

# CarrierWave.root = public_path

# module CarrierWave
#   module Test
#     module MockFiles
#       def stub_file(filename, mime_type=nil, fake_name=nil)
#         f = File.open(file_path(filename))
#         return f
#       end
#     end
#   end
# end

def create_a_file_in_the_database properties
  active_record_file_class = CarrierWave::Storage::ActiveRecord::ActiveRecordFile

  active_record_file_class.create! properties.merge!({ identifier: identifier })
end
