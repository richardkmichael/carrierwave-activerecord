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
        def store! sanitized_file
          File.create! sanitized_file, uploader.identifier
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
        def retrieve! identifier
          File.fetch! identifier
        end

        def identifier
          token = "#{uploader.filename} #{Time.now.to_s} #{rand(1000)}"

          # `uploader.identifier` is circular because CW::U::B#identifier proxies to us.
          uploader.model.read_uploader(uploader.mounted_as) || Digest::SHA1.hexdigest(token)
        end
      end # StorageProvider

    end # ActiveRecord
  end # Storage
end # CarrierWave
