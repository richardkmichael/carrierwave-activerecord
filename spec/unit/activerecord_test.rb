# -*- encoding: utf-8 -*-
require 'pry'

$:.push File.expand_path('../../../spec', __FILE__)

# require 'test_helper'
require 'spec_helper'

class AvatarUploader < CarrierWave::Uploader::Base
  storage :active_record
end

require 'carrierwave/orm/activerecord'

def initialize_database
  name = File.expand_path('../../fixtures/database.sqlite', __FILE__)
  File.delete name if File.exist? name
  name
end

database_filename = initialize_database

require 'sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => database_filename
)

ActiveRecord::Schema.define do
  # create_table :avatars do |t|
  #   t.string :name
  #   t.string :image
  #   t.timestamps
  # end

  create_table :carrier_wave_files do |t|
    t.string :original_filename
    t.string :content_type  # We need to set this..
    t.string :extension
    t.string :identifier
    t.string :size
    t.binary :data

    t.timestamps
  end
end


class Avatar < ActiveRecord::Base
  # Because of the DB columns, we don't need accessors (AR::B gives them to us).
  # attr_accessor :name, :image
# mount_uploader uploader_field, uploader_class
  mount_uploader :image, AvatarUploader
end

class CarrierWave::Storage::ActiveRecordTest < MiniTest::Unit::TestCase

  def setup

    # Setup a file, ensure it exists.
    @filename = File.expand_path('../../fixtures/tiger.jpg', __FILE__)
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
#   @model = Avatar.new( :name => 'Richard', :image => @filename )

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

    # Direct database access to verify without using ActiveRecord.
    database_file = File.expand_path('../../fixtures/database.sqlite', __FILE__)

    database = ::SQLite3::Database.open database_file

    # FIXME: Compact this to a result statement: @image_data = ::SQLite3::etc.
    database.execute(select_data_statement) do |row|
      assert_equal row.length, 1
      @image_data = row.first
    end

    # For some reason, I had to write the file, then read it back.  Insane.
    tempfile = Tempfile.new('tiger.jpg')
    tempfile.puts @image_data
    tempfile.close

    file_image_data     = File.read(@filename)
    database_image_data = File.read(tempfile.path)

    assert_equal file_image_data, database_image_data
  end

  def test_store_returns_a_file

  end

  def test_retrieve_reads_the_file_data_from_the_database

  end

  def test_retrieve_sets_a_valid_file_url

  end

end
