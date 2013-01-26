# -*- encoding: utf-8 -*-

# NOTE: We do not need to do this because CarrierWave includes ActiveRecord
#       support and has already configured the uploader.
#       See: lib/carrierwave/orm/activerecord.rb
#
# module CarrierWave
#   module ActiveRecord
#     include CarrierWave::Mount
#
#     def mount_uploader
#       # Custom stuff, such as... ?
#
#       super
#
#       # Other custom stuff...
#     end
#
#   end
# end
#
# Then include the extensions into the storage system, e.g.
#   ActiveRecord::Base.extend(CarrierWave::ActiveRecord)
#   DataMapper::Model.append_extensions(CarrierWave::DataMapper)
#   Mongoid::Document::ClassMethods.send(:include, CarrierWave::Mongoid)

# NOTE: Fix the store module here, if not in CW directly.
#       FIXME: Add an <Uploader>.#{column}_filename method too?
# module CarrierWave
#   module Uploader
#     module Store
#       def filename
#         file.respond_to?(:filename) : file.filename : @filename
#       end
#     end
#   end
# end

require 'active_record'
require 'carrierwave'

module CarrierWave
  module Storage
    module ActiveRecord
      autoload :VERSION,          'carrierwave-activerecord/storage/version'
      autoload :StorageProvider,  'carrierwave-activerecord/storage/storage_provider'
      autoload :File,             'carrierwave-activerecord/storage/file'
      autoload :ActiveRecordFile, 'carrierwave-activerecord/storage/active_record_file'
    end
  end

  module Uploader
    class Base

      add_config :downloader_path_prefix
#     add_config :active_record_tablename
#     add_config :active_record_cache

      configure do |config|
        config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.downloader_path_prefix          = '/files'
#       config.active_record_tablename         = 'carrier_wave_files'
#       config.active_record_cache             = false
      end

#     alias_method :original_cache!, :cache!

#     def cache!(new_file)
#       unless active_record_cache
#         CarrierWave::SanitizedFile.class_eval do
#           def move_to(*args); self; end
#           def copy_to(*args); self; end
#         end
#       end

#       original_cache!(new_file)
#     end

      # TODO find a better way to encapsulate this into a configuration module or similar
      def self.reset_config
        super
        configure do |config|
          config.downloader_path_prefix = '/files'
        end
      end
    end # Base
  end # Uploader
end # CarrierWave
