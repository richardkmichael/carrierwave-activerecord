# encoding: utf-8

module CarrierWave
  module Storage
    module ActiveRecord 
      class FileProxy 
        attr_reader :file

        def initialize(file)
          @file = file
        end

        def self.create!(new_file, storage_path)
          attributes = { :original_filename => new_file.original_filename,
                         :content_type      => new_file.content_type,
                         :extension         => new_file.extension,
                         :filename          => new_file.filename,
                         :size              => new_file.size,
                         :data              => new_file.read,
                         :storage_path      => storage_path }
          ar_file = File.new(attributes)
          ar_file.save
          self.new(ar_file)
        end

        def self.fetch!(identifier)
          file_record = File.find_by_storage_path(identifier)
          self.new(file_record)
        end

        def blank?
          file.nil?
        end

        def old_retrieve_code
          # begin
          file = CarrierWave::Storage::ActiveRecord::File.find_by_filename(identifier)

          # NOTE: The URL could be saved during store!(), but then if the mount point
          #       changes, the DB records would need to be re-written.  Messy.
          #       ex. URL saved with mount point "avatar", but later changes to "picture".
          file.url = '/' + [ uploader.model.class.to_s.downcase.pluralize,
            uploader.model.id,
            uploader.mounted_as.to_s.pluralize,
            file.filename ].join('/')
          file
          # rescue ActiveRecord::RecordNotFound => e
          #   raise CarrierWave::Storage::Error, I18n.translate(:'errors.messages.storage.active_record.no_record')
          # end
        end

        def url
          CarrierWave::Uploader::Base.downloader_path_prefix + file.storage_path if file
        end
      end
    end # ActiveRecord
  end # Storage
end # CarrierWave

