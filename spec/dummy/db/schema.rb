ActiveRecord::Schema.define do

  # Person
  create_table :person, :force => true do |t|
    t.string :name
    t.string :avatar

    t.timestamps
  end

  # Person has_many :avatars
  create_table :avatars do |t|
    t.string     :file
    t.references :person

    t.timestamps
  end

  # add_index :avatars, :avatar_id

  # CarrierWave::ActiveRecord storage.
  create_table :carrier_wave_files, :force => true do |t|
    t.string :original_filename
    t.string :content_type
    t.string :extension
    t.string :identifier
    t.string :size
    t.binary :data

    t.timestamps
  end

end

require 'pry'
binding.pry
