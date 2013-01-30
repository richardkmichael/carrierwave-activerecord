module CarrierWave
  module Storage
    module ActiveRecord 

      class StorageProvider

        attr_reader :uploader

        def initialize(uploader)
          @uploader = uploader
        end

        def store! sanitized_file
          @file = File.create! sanitized_file, uploader.identifier
          set_file_properties
        end

        def retrieve! identifier
          @file = File.fetch! identifier
          set_file_properties
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
          @file
        end

        def compute_url
          uploader.default_url || begin
            if defined? ::Rails.application.routes.url_helpers
              model = uploader.model

              route_helpers = ::Rails.application.routes.url_helpers
              path_method_name = "#{model.class.to_s.downcase}_path"

              url = route_helpers.send(path_method_name, model)
              url << "/#{uploader.mounted_as.to_s}"
            else
              [ CarrierWave::Uploader::Base.download_path_prefix, @file.identifier ].join '/'
            end
          end
        end

      end # StorageProvider

    end # ActiveRecord
  end # Storage
end # CarrierWave
