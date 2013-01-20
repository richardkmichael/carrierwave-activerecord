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
        @identifier ||= Digest::SHA1.hexdigest "#{uploader.filename} #{Time.now.to_s} #{rand(1000)}"
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

        attributes = { :filename     => sanitized_file.original_filename,
                       :content_type => sanitized_file.content_type,
                       :extension    => sanitized_file.extension,
                       :size         => sanitized_file.size,
                       :data         => sanitized_file.read,
                       :identifier   => identifier }

        CarrierWave::Storage::ActiveRecord::File.create! attributes
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
        CarrierWave::Storage::ActiveRecord::File.find_by_identifier! identifier
      end

      class File < ::ActiveRecord::Base
        self.table_name = 'carrier_wave_files'

        attr_accessible :identifier, :filename, :data
      end # File

    end # ActiveRecord
  end # Storage
end # CarrierWave
