# encoding: utf-8

require 'pry'

module CarrierWave
  module Storage
    module ActiveRecord 
      class StorageProvider < Abstract
        ##
        # Store a file
        #
        # === Parameters
        #
        # [file (CarrierWave::SanitizedFile)] the file to store
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def store!(file)
          # begin
          CarrierWave::Storage::ActiveRecord::FileProxy.create!(file, uploader.store_path)
          # rescue <no such table error> => e
          #   raise CarrierWave::Storage::Error, I18n.translate(:'errors.messages.storage.active_record.no_table')
          # end
        end

        ##
        # Retrieve a file
        #
        # === Parameters
        #
        # [identifier (String)] unique identifier for file
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def retrieve!(identifier)
          FileProxy.fetch!(identifier)
        end
      end 

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
                         :data              => new_file.read }
          ar_file = File.new(attributes)
          ar_file.save
          self.new(ar_file)
        end

        def self.fetch!(identifier)
          self.new(nil)
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
      end

      class File < ::ActiveRecord::Base

        # TODO: Duck-type CarrierWave::SanitizedFile, therefore need methods:
        #
        #   basename
        #   path              # => directory storage .. ?
        #   empty?            # => w.r.t size
        #   exists?           # => get this from AR#exists?  should be a class method.
        #   move_to / copy_to # => we won't need these, how to disable this for our engine?
        #   to_file           # => return a File object
        #   sanitize_regexp   # => CarrierWave::SanitizedFile.sanitize_regexp

        # TODO: Change this at runtime using a configuration setting.
        self.table_name = 'carrier_wave_files'

        attr_accessible :original_filename,
                        :content_type,
                        :extension,
                        :filename,
                        :size,
                        :data

        # Remove the file from service.
        alias_method :delete, :destroy

        # Read content of file from service.
        alias_attribute :read, :data

        # A url to the file, if available.  Set before the file is returned to CarrierWave.
        attr_accessor :url

        # Check if the file exists on the remote service.
        # TODO: Should be class method somewhere?
        def exists?
          #  self.class.exists?(:filename => filename)
          'CarrierWave::Storage::ActiveRecord::File#exists? FIXME!'
        end

        # Return all attributes from file.
        def attributes
          # TODO: What attributes should be returned?
          # The Fog storage engine returns attributes from the Fog file. ?
          # 'key'            - Key for the object
          # 'Content-Length' - Size of object contents
          # 'Content-Type'   - MIME type of object
          # 'ETag'           - Etag of object
          # 'Last-Modified'  - Last modified timestamp for object
          'CarrierWave::Storage::ActiveRecord::File#attributes FIXME!'
        end
      end # File
    end # ActiveRecord
  end # Storage
end # CarrierWave
