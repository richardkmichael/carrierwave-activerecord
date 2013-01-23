# -*- encoding: utf-8 -*-

# TODO:
#  - fixture path is messy.
#  - load path for test_helper is messy
#  - test_store_returns_a_file should return a CarrierWave::SanitizedFile (how?)
#      -> if our CW::S::AR::File < CW::SanitizedFile, we could test with f.kind_of?

# $:.push File.expand_path('../../../test', __FILE__)

require 'pry'
require 'test_helper'

class CarrierWave::Storage::ActiveRecordTest < MiniTest::Unit::TestCase

  def setup
    @filename = File.expand_path('../../../fixtures/tiger.jpg', __FILE__)
    @file     = CarrierWave::SanitizedFile.new @filename

    assert_equal @file.size, 125190, 'Setup failed: incorrect fixture file size.'
    assert_equal @file.filename, 'tiger.jpg', 'Setup failed: incorrect fixture file name.'

    @uploader = AvatarUploader.new(Avatar, :image)
    @engine   = CarrierWave::Storage::ActiveRecord.new @uploader
  end

  def test_store_writes_the_file_data_to_the_database
    stored_file = @engine.store! @file
    assert_instance_of CarrierWave::Storage::ActiveRecord::File, stored_file

    select_data_statement = %Q|
      SELECT data FROM carrier_wave_files WHERE identifier = '#{@file.identifier}'|

    @database_image = ActiveRecord::Base.connection.select_one(select_data_statement)

    file_image_data     = File.open(@filename, 'rb') { |f| f.read }
    database_image_data = @database_image['data']

    assert_equal file_image_data, database_image_data, 'Data in the file and database are not equal.'
  end

  def test_retrieve_reads_the_file_data_from_the_database
    @engine.store! @file

    retrieved_file = @engine.retrieve! @file.identifier
    assert_instance_of CarrierWave::Storage::ActiveRecord::File, retrieved_file
  end
end

class CarrierWave::Storage::ActiveRecord::FileTest < MiniTest::Unit::TestCase

  def setup
    # The URL tests need to know about the model we're mounted on, so we need models.
  end

  def test_file_identifier_is_a_sha1
    assert_match @file.identifier, /[a-z0-9]{40}/
  end

  def test_file_has_a_url
    # Test if Rails, test without Rails.
  end

  def test_model_can_have_a_file
    # Test create when a file is uploaded.
  end

  def test_model_can_not_have_a_file
    # Test create when no file is uploaded.
  end

  def test_file_can_be_deleted
  end

  def test_downloaded_file_has_correct_content
  end

  def test_missing_file_causes_exception
  end
end
