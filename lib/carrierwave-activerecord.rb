require 'carrierwave-activerecord/version'

# From lib/carrierwave.rb
CarrierWave::Storage.autoload :active_record, 'carrierwave/storage/active_record'

# Configuration is on CW::U::Base?  What about for overriding the cache?
class CarrierWave::Uploader::Base
  add_config :active_record_tablename
  add_config :active_record_nocache

  configure do |config|
    config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord'
    config.active_record_tablename = 'carrierwave_files'
    config.active_record_nocache = false
  end
end

module Carrierwave
  module Uploader
    class Base

      # TODO: This overrides the cache; make this configurable?  SanitizeFile
      #       expects the local file system to be available as a cache; by-pass it.
      if self.config.active_record_nocache?
        class ::CarrierWave::SanitizedFile
          # WET code, but __method__ doesn't return the aliased name when using alias_method.
          def move_to(*args)
            Rails.logger.info "move_to called by: #{caller[0...10]}"
            self # FIXME: Needs to return a SanitizedFile, hack it with self.
          end

          def copy_to(*args)
            Rails.logger.info "copy_to called by: #{caller[0...10]}"
            self # FIXME: Needs to return a SanitizedFile, hack it with self.
          end
        end
      end
    end # Base
  end # Uploader

  # module Activerecord
  #   # Your code goes here...
  # end
end

