require 'active_record'
require 'carrierwave'

module CarrierWave
  module Storage
    module ActiveRecord
      autoload :VERSION,          'carrierwave-activerecord/storage/version'
      autoload :StorageProvider,  'carrierwave-activerecord/storage/storage_provider'
      autoload :File,             'carrierwave-activerecord/storage/file'
    end
  end

  module Uploader
    class Base
      add_config :active_record_tablename
      add_config :active_record_cache
      add_config :downloader_path_prefix

      configure do |config|
        config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.active_record_tablename         = 'carrier_wave_files'
        config.active_record_cache             = false
        config.downloader_path_prefix          = '/files'
      end

      alias_method :original_cache!, :cache!

      def cache!(new_file)
        unless active_record_cache
          CarrierWave::SanitizedFile.class_eval do
            def move_to(*args); self; end
            def copy_to(*args); self; end
          end
        end

        original_cache!(new_file)
      end

      # TODO find a better way to encapsulate this into a configuration module or similar
      def self.reset_config
        super
        configure do |config|
          config.downloader_path_prefix = "/files"
        end
      end
    end
  end
end
