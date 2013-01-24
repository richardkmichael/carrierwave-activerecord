module CarrierWave
  module Storage
    module ActiveRecord 

      class File
        attr_reader :file

        def self.create!(new_file, storage_path)
          attributes = { :original_filename => new_file.original_filename,
                         :content_type      => new_file.content_type,
                         :extension         => new_file.extension,
                         :filename          => new_file.filename,
                         :size              => new_file.size,
                         :data              => new_file.read,
                         :storage_path      => storage_path }

          active_record_file = ActiveRecordFile.new(attributes)
          active_record_file.save

          self.new(active_record_file)
        end

        def self.fetch!(identifier)
          file_record = ActiveRecordFile.find_by_storage_path(identifier)
          self.new(file_record)
        end

        def self.delete_all
          ActiveRecordFile.delete_all
        end

        def initialize(file)
          @file = file
        end

        def blank?
          file.nil?
        end

        def delete
          if file
            file.destroy
          else
            false
          end
        end

        def url
          CarrierWave::Uploader::Base.downloader_path_prefix + file.storage_path if file
        end
      end # File

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
                        :storage_path
      end # ActiveRecordFile

    end # ActiveRecord
  end # Storage
end # CarrierWave
