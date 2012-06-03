# Carrierwave::Activerecord

TODO: Write a gem description

## Installation

### Add the gem

Add this line to your Gemfile:

    gem 'carrierwave-activerecord'

And then execute:

    $ bundle

Or install manually:

    $ gem install carrierwave-activerecord

### Prepare the database

$ rails g migration create_carrier_wave_files

```ruby
class CreateCarrierWaveFiles < ActiveRecord::Migration
  def change
    create_table :carrier_wave_files do |t|
      t.string :original_filename
      t.string :content_type
      t.string :extension
      t.string :identifier
      t.string :size
      t.binary :data

      t.timestamps
    end
  end
end
```

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## How to add a storage engine


[3] pry(#<CarrierWave::Mount::Mounter>)> self
=> #<CarrierWave::Mount::Mounter:0x00000102b67aa8
 @column=:file,
 @integrity_error=nil,
 @options={},
 @processing_error=nil,
 @record=
  #<ArticleFile id: 5, file: "Screen_shot_2012-05-30_at_1.30.08_PM.png", article_id: 4, created_at: "2012-06-02 11:42:10", updated_at: "2012-06-02 11:42:10">,
 @uploader=,
 @uploader_options={:mount_on=>nil}>
