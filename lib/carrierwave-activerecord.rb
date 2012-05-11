require 'carrierwave'

require 'carrierwave-activerecord/version'

CarrierWave::Storage.autoload :ActiveRecord, 'carrierwave-activerecord/storage/active_record'

class CarrierWave::Uploader::Base
  add_config :active_record_tablename
  add_config :active_record_cache

  configure do |config|
    config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord'
    config.active_record_tablename         = 'carrier_wave_files'
    config.active_record_cache             = false
  end

  alias_method :original_cache!, :cache!

  def cache!(new_file)
    unless active_record_cache
      CarrierWave::SanitizedFile.class_eval do
        # Rails.logger.info "move_to called by: #{caller[0...10]}"
        # Rails.logger.info "copy_to called by: #{caller[0...10]}"
        def move_to(*args); self; end
        def copy_to(*args); self; end
      end
    end

    original_cache!(new_file)
  end
end
