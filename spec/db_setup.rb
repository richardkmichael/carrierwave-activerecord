ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => ":memory:"
)
ActiveRecord::Schema.define do
  create_table :carrier_wave_files do |t|
    t.string :original_filename
    t.string :content_type
    t.string :extension
    t.string :filename
    t.integer :size
    t.binary :data
    t.string :storage_path

    t.timestamps
  end
end
