# -*- encoding: utf-8 -*-
require 'active_record'
require 'digest'

module CarrierWave
  module Storage
    class ActiveRecord < Abstract

      # Inherited from Abstract:
      #   attr_reader :uploader
      #   def initialize(uploader)  ; @uploader = uploader ; end
      #   def identifier            ; uploader.filename    ; end
      #   def store!(file)          ;                        end
      #   def retrieve!(identifier) ;                        end


      # CarrierWave overwrites an existing file when a new file with the same
      # name is uploaded (even if handled by different uploaders), because
      # 'store_dir' defaults to '/public/uploads'.  NOTE: The storage path may
      # be configured per uploader by defining 'store_dir'.  However, because
      # we store in the database, this is not particularly helpful.
      #
      # All uploaded files are stored together in a single table.  This means
      # we cannot use filenames or model ID's as the identifier, e.g. there
      # could be many files with the same name uploaded; or, one model could
      # have multiple uploaded files; or, two models could have the same ID
      # such as @house.id = @book.id = 42.
      #
      # Override CarrierWave::Storage::Abstract#identifier() (which returns
      # @uploader.filename) to use a SHA1 of the filename, time and random
      # number (to avoid time collisions) as the identifier stored in the
      # mounted column.

      def identifier
        token = "#{uploader.filename} #{Time.now.to_s} #{rand(1000)}"
        @identifier ||= Digest::SHA1.hexdigest token
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
      def store! sanitized_file
        engine_file = CarrierWave::Storage::ActiveRecord::File.new(uploader)#, uploader.store_path)
        engine_file.write sanitized_file
        engine_file
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
      def retrieve! identifier
        # CarrierWave::Storage::ActiveRecord::File.find_by_identifier! identifier
        CarrierWave::Storage::ActiveRecord::File.new(uploader)#, uploader.store_path(identifier))
      end

      class File

        def initialize(uploader)#, path)
          @uploader = uploader
#         @path = path
        end

        def write(sanitized_file)
          attributes = { :identifier   => @uploader.identifier,
                         :filename     => sanitized_file.original_filename,
                         :data         => sanitized_file.read }

          # This should duck-type CW::SanitizedFile.
          ActiveRecordFile.create! attributes
        end

        def read
          engine_file = ActiveRecordFile.find_by_identifier!(@uploader.identifier)
          engine_file.data
        end

        def url
          # binding.pry
          "#{self.class} FIXME: File should define a URL."
        end

        private

        class ActiveRecordFile < ::ActiveRecord::Base
          self.table_name = 'carrier_wave_files'

          attr_accessible :identifier, :filename, :data
        end

      end # File

    end # ActiveRecord
  end # Storage
end # CarrierWave
