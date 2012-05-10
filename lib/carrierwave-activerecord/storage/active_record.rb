# encoding: utf-8

require 'pry'

module CarrierWave
  module Storage

    class ActiveRecord < Abstract

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
        attributes = { :original_filename => file.original_filename,
                       :content_type      => file.content_type,
                       :extension         => file.extension,
                       :filename          => file.filename,
                       :size              => file.size,
                       :data              => file.read }

        # begin
        CarrierWave::Storage::ActiveRecord::File.create!(attributes)
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
