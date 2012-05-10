require 'carrierwave'

require 'carrierwave-activerecord/version'

CarrierWave::Storage.autoload :active_record, 'carrierwave/storage/active_record'

class CarrierWave::Uploader::Base
  add_config :active_record_tablename
  add_config :active_record_nocache

  configure do |config|
    config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord'
    config.active_record_tablename         = 'carrier_wave_files'
    config.active_record_nocache           = false
  end
end

module Carrierwave
  module Uploader
    class Base

      if self.config.active_record_nocache?
        class ::CarrierWave::SanitizedFile
          # Rails.logger.info "copy_to called by: #{caller[0...10]}"
          # Rails.logger.info "move_to called by: #{caller[0...10]}"
          def move_to(*args); self; end
          def copy_to(*args); self; end
        end
      end

    end # Base
  end # Uploader

end

