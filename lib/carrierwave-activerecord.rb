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
    end # Base

    module Cache

      # Minimally override CarrierWave::Uploader::Cache#cache!  Copied directly
      # from CarrierWave, except wrap "if move_to_cache ; .. ; end" to prevent
      # filesystem access.

      def cache!(new_file = sanitized_file)
        new_file = CarrierWave::SanitizedFile.new(new_file)

        unless new_file.empty?
          raise CarrierWave::FormNotMultipart if new_file.is_path? && ensure_multipart_form

          with_callbacks(:cache, new_file) do
            self.cache_id = CarrierWave.generate_cache_id unless cache_id

            @filename = new_file.filename
            self.original_filename = new_file.filename

            if use_filesystem_cache
              if move_to_cache
                @file = new_file.move_to(cache_path, permissions, directory_permissions)
              else
                @file = new_file.copy_to(cache_path, permissions, directory_permissions)
              end
            end
          end
        end
      end
    end # Cache

  end # Uploader
end # CarrierWave
