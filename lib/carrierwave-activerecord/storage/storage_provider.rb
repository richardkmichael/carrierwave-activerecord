# encoding: utf-8

module CarrierWave
  module Storage
    module ActiveRecord 
      class StorageProvider < Abstract
        ##
        # Store a file
        #
        # === Parameters
        #
        # [file (CarrierWave::SanitizedFile)] the file to store
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def store!(file)
          CarrierWave::Storage::ActiveRecord::FileProxy.create!(file, uploader.store_path)
        end

        ##
        # Retrieve a file
        #
        # === Parameters
        #
        # [identifier (String)] unique identifier for file
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def retrieve!(identifier)
          FileProxy.fetch!(identifier)
        end
      end 
    end # ActiveRecord
  end # Storage
end # CarrierWave
