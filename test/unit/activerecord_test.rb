# -*- encoding: utf-8 -*-
# TODO:
#  - fixture path is messy.
#  - load path for test_helper is messy
#
# $:.push File.expand_path('../../../test', __FILE__)

require 'pry'
require 'test_helper'

class CarrierWave::Storage::ActiveRecordTest < MiniTest::Unit::TestCase

  def setup

    # Setup a file, ensure it exists.
    @filename = File.expand_path('../../../fixtures/tiger.jpg', __FILE__)
    @file = CarrierWave::SanitizedFile.new @filename

    # The Uploader would set this?
    # assert_equal @file.content_type, 'image/jpeg'
    assert_equal @file.size, 125190
    assert_equal @file.filename, 'tiger.jpg'

    # Normally the 'mount_uploader' in the model would create the uploader, but it won't
    # give it back to us, and we need it exposed.
    @uploader = AvatarUploader.new(Avatar, :image)

    # As a subclass of Abstract, it expects an Uploader.  However anything that responds
    # to #filename will do...?
    @engine = CarrierWave::Storage::ActiveRecord.new @uploader

    # Can't do this because CarrierWave wants a MultiPart form somewhere.
  # @model = Avatar.new( :name => 'Richard', :image => @filename )

  # @uploader_field  = :image
  # @uploader_class  = FileUploader

  # @model_class    = Class.new(ActiveRecord::Base) do
  #   attr_accessor :name, :image
  #   mount_uploader uploader_field, uploader_class
  # end
  end

  def test_identifier_returns_sha1
    assert_match @engine.identifier, /[a-z0-9]{40}/
  end

  def test_store_writes_the_file_data_to_the_database
    @engine.store! @file

    select_data_statement = %Q|
      SELECT data FROM carrier_wave_files WHERE identifier = '#{@engine.identifier}'|

    @database_image = ActiveRecord::Base.connection.select_one(select_data_statement)

    file_image_data     = File.open(@filename, 'rb') { |f| f.read }
    database_image_data = @database_image['data']

    assert_equal file_image_data, database_image_data
  end

# def test_store_returns_a_file

# end

# def test_retrieve_reads_the_file_data_from_the_database

# end

# def test_retrieve_sets_a_valid_file_url

# end

end
