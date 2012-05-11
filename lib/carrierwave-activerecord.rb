require 'carrierwave'

require 'carrierwave-activerecord/version'

CarrierWave::Storage.autoload :ActiveRecord, 'carrierwave/storage/active_record'

class CarrierWave::Uploader::Base
  add_config :active_record_tablename
  add_config :active_record_nocache

  configure do |config|
    config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord'
    config.active_record_tablename         = 'carrier_wave_files'
    config.active_record_nocache           = false
  end

# def move_to_cache
#   false
# end

# def copy_to_cache
#   false
# end
end

# FIXME: This feels like a horrible hack, but where else to inject the method
# overriding into SanitizedFile?

# module Carrierwave
#   module Uploader
#     module Base

#arrierWave::Uploader::Base.class_eval do

#     alias_method :original_store!, :store!

#     def store!
#       # FIXME: Needs a class_eval to do this in the Uploader instance.
#       if self.active_record_nocache?
#         ::CarrierWave::SanitizedFile.class_eval do
#           # Rails.logger.info "copy_to called by: #{caller[0...10]}"
#           # Rails.logger.info "move_to called by: #{caller[0...10]}"
#           def move_to(*args); self; end
#           def copy_to(*args); self; end
#         end
#       end

#       original_store!
#     end # #store!

#   end # Store
# end # Uploader
end
