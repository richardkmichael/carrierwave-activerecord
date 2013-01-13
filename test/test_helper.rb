# -*- encoding: utf-8 -*-

require 'rubygems'
require 'bundler/setup'

require 'minitest/autorun'

require 'carrierwave-activerecord'
require 'carrierwave/orm/activerecord'


ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3',
                                        :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :carrier_wave_files do |t|
    t.string :original_filename
    t.string :content_type  # We need to set this..
    t.string :extension
    t.string :identifier
    t.string :size
    t.binary :data

    t.timestamps
  end

  create_table :avatars do |t|
    t.string :image
  end
end

class AvatarUploader < CarrierWave::Uploader::Base
  storage :active_record
end

class Avatar < ActiveRecord::Base
  mount_uploader :image, AvatarUploader
end
