module CarrierWave
  module Storage
    module ActiveRecord 

      class File

        def self.create!(new_file, identifier)
          attributes = { :original_filename => new_file.original_filename,
                         :content_type      => new_file.content_type,
                         :extension         => new_file.extension,
                         :filename          => new_file.filename,
                         :size              => new_file.size,
                         :data              => new_file.read,
                         :identifier        => identifier }

          active_record_file = ActiveRecordFile.new attributes
          active_record_file.save

          self.new active_record_file
        end

        def self.fetch! identifier
          self.new ActiveRecordFile.find_by_identifier identifier
        end

        def self.delete_all
          ActiveRecordFile.delete_all
        end

        attr_reader :file

        attr_accessor :url

        def initialize(file = nil)
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

        def identifier
          file.identifier
        end
      end # File

    end # ActiveRecord
  end # Storage
end # CarrierWave
