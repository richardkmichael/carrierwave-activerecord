module CarrierWave
  module Storage
    module ActiveRecord

      class ActiveRecordFile < ::ActiveRecord::Base
        self.table_name = 'carrier_wave_files'

        alias_method    :delete, :destroy
        alias_attribute :read, :data

        attr_accessible :original_filename,
                        :content_type,
                        :extension,
                        :filename,
                        :size,
                        :data,
                        :identifier
      end # ActiveRecordFile

    end # ActiveRecord
  end # Storage
end # CarrierWave
