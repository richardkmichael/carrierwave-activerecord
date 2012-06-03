# encoding: utf-8

# TODO: investigate versioning?  should we store a tuple: [sha1, filename] ?

require 'digest'

module CarrierWave
  module Storage

    class ActiveRecord < Abstract

      # Change the identifier which is stored in the mounted column; this
      # allows storage of duplicate files.  Normally, carrierwave uses the
      # filename here, and then overwrites files with the same name (even if
      # handled by different uploaders) because the 'store_dir' defaults to
      # '/public/uploads'.  The upload path may be configured per uploader by
      # defining 'store_dir'.

      # We can't use "model.id", because ids can collide because the engine
      # storage is not [necessarily] specific to a model.

      # class House < AR::Base
      #   attr_accessor :photo
      #   mount_uploader :photo, PhotoUploader
      # end

      # class Person < AR::Base
      #   attr_accessor :mugshot
      #   mount_uploader :mugshot, MugshotUploader
      # end

      # @house.id  # => 42
      # @person.id # => 42

      def identifier
        # FIXME: identifier ||= "#{model.name} #{model.id}" for column value readability?
        @identifier ||= "#{uploader.filename} #{Time.now.to_s} #{rand(1000)}"
        Digest::SHA1.hexdigest(@identifier)
      end

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
                       :identifier        => self.identifier,
                       :extension         => file.extension,
                       :size              => file.size,
                       :data              => file.read }

        # TODO: Error handling in case the migration has not been run.
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
        file = CarrierWave::Storage::ActiveRecord::File.find_by_identifier(identifier)

        #  The URL could be saved during store!(), but then if the mount point
        #  changes, the DB records would need to be re-written (messy).
        #  ex. URL saved with mount point "avatar", but later changes to "picture".
        # /articles/1/file/my_file.txt

        # FIXME: "model.class.to_s.downcase.pluralize" is not rails convention, what we need
        #        here is something like "controller_name_for_model(model)", because
        #        camelcased model names, use controller names with underscores.
        #        ex. ArticleFile => '/article_files/'

        # This hints the filename in the URL. Unnecessary (we only need :id), but helpful.
        file.url = '/' + [ uploader.model.class.to_s.downcase.pluralize,
                           uploader.model.id,
                           uploader.mounted_as.to_s,
                           file.original_filename ].join('/')

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
        # self.table_name = uploader.config.active_record_tablename
        self.table_name = 'carrier_wave_files'

        attr_accessible :original_filename,
                        :content_type,
                        :identifier,
                        :extension,
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
