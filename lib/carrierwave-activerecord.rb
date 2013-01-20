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
  configure do |config|
    config.storage_engines[:active_record] = 'CarrierWave::Storage::ActiveRecord'
  end
end
