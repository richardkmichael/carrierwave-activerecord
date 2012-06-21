# -*- encoding: utf-8 -*-

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'carrierwave-activerecord'

# ActiveRecord::Base.connection do |database|
#   database = 'sqlite3::memory' # Keep tests fast.
#   # TODO: database = 'postgres' --> but really, we should only use AR's API and it should handle the DB for us.
# end

# ActiveRecord::Schema.load do
#   # Create CW storage tables.
# end

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
