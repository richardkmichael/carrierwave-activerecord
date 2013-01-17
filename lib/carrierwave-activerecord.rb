# -*- encoding: utf-8 -*-
require 'carrierwave'

# NOTE: We do not need to do this because CarrierWave includes ActiveRecord
#       support and has already configured the uploader.
#       See: lib/carrierwave/orm/activerecord.rb
#
# module CarrierWave
#   module ActiveRecord
#     include CarrierWave::Mount
#
#     def mount_uploader
#       # Custom stuff, such as... ?
#
#       super
#
#       # Other custom stuff...
#     end
#
#   end
# end
#
# Then include the extensions into the storage system, e.g.
#   ActiveRecord::Base.extend(CarrierWave::ActiveRecord)
#   DataMapper::Model.append_extensions(CarrierWave::DataMapper)
#   Mongoid::Document::ClassMethods.send(:include, CarrierWave::Mongoid)

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

  def cache! new_file
    unless active_record_cache

      # TODO: Can the alias_method and original_cache! calls be done here,
      #       inside unless?  Perhaps with "class_eval << ..." ?

      CarrierWave::SanitizedFile.class_eval do
        def move_to(*args); self; end
        def copy_to(*args); self; end
      end
    end

    original_cache!(new_file)
  end
end
