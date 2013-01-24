ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                         database: ':memory:' )
ActiveRecord::Schema.define do
  create_table :carrier_wave_files do |t|
    t.string  :original_filename
    t.string  :content_type
    t.string  :extension
    t.string  :filename
    t.string  :storage_path
    t.binary  :data
    t.integer :size

    t.timestamps
  end
end
