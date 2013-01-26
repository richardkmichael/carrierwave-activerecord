# encoding: utf-8

module CarrierWave
  module Storage
    module ActiveRecord 

      class StorageProvider < Abstract

        CUSTOM_URL = 'When not using Rails, you must define default_url in your uploader class.'

        # Inherited from Abstract:
        #   attr_reader :uploader
        #   def initialize(uploader)  ; @uploader = uploader ; end
        #   def identifier            ; uploader.filename    ; end
        #   def store!(file)          ;                        end
        #   def retrieve!(identifier) ;                        end

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
          @file = File.create! sanitized_file, uploader.identifier
          set_file_properties
          @file
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
          @file = File.fetch! identifier
          set_file_properties
          @file
        end

        def identifier
          @identifier ||= begin
                            token = "#{uploader.filename} #{Time.now.to_s} #{rand(1000)}"
                            Digest::SHA1.hexdigest token
                          end
        end

        private

        def set_file_properties
          @file.url = compute_url
        end

        def compute_url
          if defined? ::Rails.application.routes.url_helpers
            model = uploader.model

            route_helpers = ::Rails.application.routes.url_helpers
            path_method_name = "#{model.class.to_s.downcase}_path"

            url = route_helpers.send(path_method_name, model)
            url << "/#{uploader.mounted_as.to_s}"
          else
            CUSTOM_URL
            # CarrierWave::Uploader::Base.downloader_path_prefix + @file.identifier if @file
          end
        end

      end # StorageProvider

    end # ActiveRecord
  end # Storage
end # CarrierWave
