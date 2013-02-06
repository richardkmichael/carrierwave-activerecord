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

      add_config :download_path_prefix
      add_config :active_record_tablename
      add_config :use_filesystem_cache

      configure do |config|
        config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.download_path_prefix            = '/files'
        config.active_record_tablename         = 'carrier_wave_files'
        config.use_filesystem_cache            = true
      end

      def self.reset_config
        super
        configure do |config|
          config.download_path_prefix    = '/files'
          config.active_record_tablename = 'carrier_wave_files'
          config.use_filesystem_cache    = true
        end
      end


      # TODO: Modifying CarrierWave internals to disable the cache is bad...?
      alias_method :original_cache!, :cache!

      def cache! new_file
        unless use_filesystem_cache
          CarrierWave::SanitizedFile.class_eval do
            def move_to *args; self; end
            def copy_to *args; self; end
          end
        end

        original_cache! new_file
      end

    end # Base
  end # Uploader

end # CarrierWave
