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

      configure do |config|
        config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord::StorageProvider'
        config.download_path_prefix            = '/files'
      end

      # TODO find a better way to encapsulate this into a configuration module or similar
      def self.reset_config
        super
        configure do |config|
          config.download_path_prefix = '/files'
        end
      end
    end # Base
  end # Uploader
end # CarrierWave
