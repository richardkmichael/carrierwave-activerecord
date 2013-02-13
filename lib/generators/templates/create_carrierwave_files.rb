class CreateCarrierwaveFiles < ActiveRecord::Migration
  def change
    create_table :carrier_wave_files do |t|
      t.string :identifier
      t.string :original_filename
      t.string :content_type
      t.string :size
      t.binary :data

      t.timestamps
    end
  end
end
